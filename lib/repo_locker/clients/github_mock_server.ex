defmodule RepoLocker.Clients.GithubMockServer do
  @moduledoc """
  Github Mock Server for Testing
  """
  use Plug.Router

  plug(Plug.Parsers,
    parsers: [:json],
    pass: ["text/*"],
    json_decoder: Jason
  )

  plug(:match)
  plug(:dispatch)

  get "/repos/:org_name/:repo_name/branches" do
    success(conn, %{})
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
