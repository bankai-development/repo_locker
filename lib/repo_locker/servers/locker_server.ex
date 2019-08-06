defmodule RepoLocker.Servers.LockerServer do
  @moduledoc """
  Locker Callback Server
  """
  use Plug.Router

  plug(RepoLocker.Authentication)

  if Mix.env() == :dev do
    use Plug.Debugger
  end

  plug(Plug.Parsers,
    parsers: [:urlencoded, :json],
    pass: ["*/*"],
    json_decoder: Jason
  )

  plug(Plug.Logger)
  plug(:match)
  plug(:dispatch)

  get "/healthz" do
    body = Jason.encode!(%{"status" => "alive"})
    Plug.Conn.send_resp(conn, 200, body)
  end

  post "/notifications" do
    process(List.keyfind(conn.req_headers, "x-github-event", 0), conn)
  end

  match(_) do
    conn
    |> Plug.Conn.resp(404, "Not found")
    |> Plug.Conn.send_resp()
  end

  def process({"x-github-event", "create"}, conn) do
    payload_params = payload_params(conn)

    with {:ok, "branch"} <- {:ok, payload_params["ref_type"]},
         {:ok, "master"} <- {:ok, payload_params["ref"]},
         {:ok, owner, repo} <- repo_info_from_params(payload_params),
         {:ok, _locks} <- RepoLocker.lock(owner, repo) do
      no_content(conn)
    else
      {:error, msg} ->
        Plug.Conn.resp(conn, 401, msg)

      _ ->
        not_found(conn)
    end
  end

  def process(_, conn) do
    not_found(conn)
  end

  defp no_content(conn) do
    conn
    |> Plug.Conn.resp(204, "No Content")
    |> Plug.Conn.send_resp()
  end

  defp not_found(conn) do
    conn
    |> Plug.Conn.resp(404, "Not Found")
    |> Plug.Conn.send_resp()
  end

  defp payload_params(conn) do
    conn.params["payload"] |> Jason.decode!()
  end

  defp repo_info_from_params(params) do
    {:ok, params["repository"]["owner"]["login"], params["repository"]["name"]}
  end
end
