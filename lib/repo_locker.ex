defmodule RepoLocker do
  @moduledoc """
  This module makes calls to secure or lock up a repository.
  """
  alias RepoLocker.Clients.Github, as: GithubClient

  @spec lock(String.t(), String.t()) :: {:ok, RepoLocker.Locks.t()} | {:error, String.t()}
  def lock(user, repo) do
    GithubClient.lock(user, repo)
  end
end
