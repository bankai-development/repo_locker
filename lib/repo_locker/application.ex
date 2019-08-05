defmodule RepoLocker.Application do
  @moduledoc false
  require Logger

  use Application

  def start(_type, args) do
    Logger.info("Starting Repo Locker ...")

    children =
      case args do
        [env: :test] ->
          [
            Plug.Cowboy.child_spec(
              scheme: :http,
              plug: RepoLocker.Servers.GithubMockServer,
              options: [port: 8081]
            )
          ]

        [_] ->
          [locker_server()]
      end

    opts = [strategy: :one_for_one, name: RepoLocker.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def locker_server() do
    Plug.Cowboy.child_spec(
      scheme: :http,
      plug: RepoLocker.Servers.LockerServer,
      options: [port: System.get_env()["PORT"] || 4000]
    )
  end
end
