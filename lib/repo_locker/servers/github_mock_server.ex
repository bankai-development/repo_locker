defmodule RepoLocker.Servers.GithubMockServer do
  @moduledoc """
  Github Mock Server for Testing
  """
  use Plug.Router

  plug(Plug.Parsers,
    parsers: [:json],
    pass: ["*/*"],
    json_decoder: Jason
  )

  plug(:match)
  plug(:dispatch)

  get "/healthz" do
    success(conn, %{"status" => "alive"})
  end

  put "/repos/:owner/:repo/branches/:branch/protection" do
    success(conn, %{"owner" => owner})
  end

  defp success(conn, body \\ "") do
    conn
    |> Plug.Conn.send_resp(200, Jason.encode!(body))
  end

  defp failure(conn) do
    conn
    |> Plug.Conn.send_resp(422, Jason.encode!(%{message: "error message"}))
  end
end
