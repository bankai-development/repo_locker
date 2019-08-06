defmodule RepoLocker do
  @moduledoc """
  This module makes calls to secure or lock up a repository.
  """
  alias RepoLocker.Clients.Github, as: GithubClient

  @response_base_path "./lib/repo_locker/messages/"

  @spec lock(String.t(), String.t()) :: {:ok, RepoLocker.Locks.t()} | {:error, String.t()}
  def lock(user, repo) do
    with {:ok, lock_resp} <- GithubClient.lock(user, repo),
         {:ok, _issue_rep} <- GithubClient.create_issue(user, repo, lock_message(user)) do
      {:ok, lock_resp}
    else
      err -> err
    end
  end

  defp lock_message(user) do
    mention = System.get_env("MENTION_TARGET", user)
    %{"title" => "Repo Master Locked", "body" => render_message("lock_message.txt.md", mention)}
  end

  defp render_message(filename, mention) do
    [@response_base_path, filename]
    |> Enum.join()
    |> Path.expand()
    |> EEx.eval_file(mention: mention)
  end
end
