defmodule RepoLocker.Clients.Github do
  @moduledoc """
  Github Client
  """
  use HTTPoison.Base

  # API
  def lock(user, repo) do
    lock_settings_json = Jason.encode!(lock_settings())

    response =
      __MODULE__.put!(
        "/repos/#{user}/#{repo}/branches/master/protection",
        lock_settings_json,
        [],
        []
      )

    case response do
      %{:status_code => 200, :body => body} ->
        {:ok, translate_locks(body)}

      %{:status_code => _status, :body => body} ->
        {:error, body["message"]}
    end
  end

  def create_issue(user, repo, message) do
    response = __MODULE__.post!("/repos/#{user}/#{repo}/issues", Jason.encode!(message), [], [])

    case response do
      %{:status_code => 201, :body => body} ->
        {:ok, body}

      %{:status_code => _status, :body => body} ->
        {:error, body["message"]}
    end
  end

  # Implementation Details
  def base_url do
    System.get_env("GITHUB_BASE_URL", "https://api.github.com")
  end

  def process_url(url) do
    base_url() <> url
  end

  def default_headers do
    token = "token " <> System.get_env("GITHUB_TOKEN", "")

    %{
      "Accept" => "application/vnd.github.luke-cage-preview+json",
      "Content-Type" => "application/json",
      "Authorization" => token
    }
  end

  def process_request_headers(headers) when is_map(headers) do
    default_headers()
    |> Map.merge(headers)
    |> Map.to_list()
  end

  def process_request_headers(_headers) do
    Map.to_list(default_headers())
  end

  def process_response_body(body) do
    body |> Jason.decode!()
  end

  def lock_settings do
    %{
      enforce_admins: true,
      required_pull_request_reviews: %{
        dismiss_stale_reviews: false,
        require_code_owner_reviews: false,
        required_approving_review_count: 1
      },
      required_status_checks: %{
        strict: true,
        contexts: []
      },
      restrictions: %{
        teams: [],
        users: []
      }
    }
  end

  defp translate_locks(resp) do
    %{"repo" => repo, "branch" => branch} =
      Regex.named_captures(
        ~r/\/repos\/(?<repo>.[^\/]*).*\/branches\/(?<branch>.*)\//,
        resp["url"]
      )

    %RepoLocker.Locks{
      branch: branch,
      enforce_admins: resp["enforce_admins"]["enabled"],
      require_code_owner_reviews:
        resp["required_pull_request_reviews"]["require_code_owner_reviews"],
      repo: repo,
      restrictions: %{
        users: Enum.map(resp["restrictions"]["users"], fn user -> user["login"] end),
        teams: Enum.map(resp["restrictions"]["teams"], fn team -> team["slug"] end)
      }
    }
  end
end
