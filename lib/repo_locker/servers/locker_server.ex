defmodule RepoLocker.Servers.LockerServer do
  @moduledoc """
  Locker Callback Server
  """
  use Plug.Router

  if Mix.env() == :dev do
    use Plug.Debugger
  end

  if Mix.env() == :prod do
    plug(Plug.SSL, rewrite_on: [:x_forwarded_proto])
  end

  plug(Plug.Parsers,
    parsers: [:json],
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

  def process({"x-github-event", "repository"}, conn) do
    with {:ok, "created"} <- {:ok, conn.body_params["action"]},
         {:ok, owner, repo} <- repo_info_from_params(conn),
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

  defp repo_info_from_params(conn) do
    {:ok, conn.body_params["repository"]["owner"]["login"],
     conn.body_params["repository"]["name"]}
  end
end
