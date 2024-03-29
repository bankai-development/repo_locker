defmodule RepoLocker.MixProject do
  use Mix.Project

  @elixir_version "~> 1.9"

  def project do
    [
      app: :repo_locker,
      version: "0.9.0",
      elixir: @elixir_version,
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger],
      mod: {RepoLocker.Application, [env: Mix.env()]},
      applications: [:httpoison, :plug_cowboy, :eex, :jason]
    ]
  end

  defp deps do
    [
      {:credo, "~> 1.1.1", only: [:dev, :test], runtime: false},
      {:excoveralls, "~> 0.10", only: :test},
      {:httpoison, "~> 1.4"},
      {:jason, "~> 1.1"},
      {:plug_cowboy, "~> 2.1.0"}
    ]
  end
end
