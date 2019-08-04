defmodule RepoLocker.Application do
  @moduledoc false

  use Application

  def start(_type, args) do
    children =
      case args do
        [env: :test] ->
          [
            {Plug.Cowboy,
             scheme: :http, plug: RepoLocker.Clients.GithubMockServer, options: [port: 8081]}
          ]

        [_] ->
          []
      end

    opts = [strategy: :one_for_one, name: RepoLocker.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
