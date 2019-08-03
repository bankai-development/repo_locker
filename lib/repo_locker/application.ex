defmodule RepoLocker.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Starts a worker by calling: RepoLocker.Worker.start_link(arg)
      # {RepoLocker.Worker, arg}
    ]

    opts = [strategy: :one_for_one, name: RepoLocker.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
