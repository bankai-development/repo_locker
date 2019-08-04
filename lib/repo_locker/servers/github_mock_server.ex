defmodule RepoLocker.Servers.GithubMockServer do
  @moduledoc """
  Github Mock Server for Testing
  """
  use Plug.Router

  @response_base_path "./lib/repo_locker/servers/github_mock_server/"

  plug(Plug.Parsers,
    parsers: [:json],
    pass: ["*/*"],
    json_decoder: Jason
  )

  plug(:match)
  plug(:dispatch)

  get "/healthz" do
    success(conn, Jason.encode!(%{"status" => "alive"}))
  end
  
  put "/repos/bad-owner/:repo/branches/:branch/protection" do
    failure(conn)
  end

  put "/repos/:owner/:repo/branches/:branch/protection" do
    bindings = [owner: conn.params["owner"], repo: conn.params["repo"], branch: conn.params["branch"]]
    "repos/branches/update_branch_protection.json"
    |> json_response(bindings)
    |> success(conn)
  end
  
  defp success(body, conn) do
    conn
    |> Plug.Conn.send_resp(200, body)
  end

  defp failure(conn) do
    conn
    |> Plug.Conn.send_resp(422, Jason.encode!(%{message: "error message"}))
  end

  defp json_response(path_to_file, bindings) do
    [@response_base_path, path_to_file]
    |> Enum.join
    |> Path.expand
    |> EEx.eval_file(bindings)
  end
end
