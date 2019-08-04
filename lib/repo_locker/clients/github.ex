defmodule RepoLocker.Clients.Github do
  @moduledoc """
  Github Client
  """
  use HTTPoison.Base

  def base_url do
    System.get_env("GITHUB_BASE_URL", "https://api.github.com/")
  end

  def process_url(url) do
    base_url() <> url
  end

  def process_response_body(body) do
    body |> Jason.decode!()
  end
end
