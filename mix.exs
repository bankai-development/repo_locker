defmodule RepoLocker.MixProject do
  use Mix.Project

  def project do
    [
      app: :repo_locker,
      version: "0.9.0",
      elixir: "~> 1.9",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger],
      mod: {RepoLocker.Application, []}
    ]
  end

  defp deps do
    [
      {:plug_cowboy, "~> 2.0"},
      {:credo, "~> 1.1.1", only: [:dev, :test], runtime: false},
      {:excoveralls, "~> 0.10", only: :test},
      {:httpoison, "~> 1.4"}
    ]
  end
end
