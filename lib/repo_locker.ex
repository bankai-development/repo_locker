defmodule RepoLocker do
  @moduledoc """
  This module makes calls to secure or lock up a repository.
  """
  alias RepoLocker.Clients.Github, as: GithubClient

  @spec lock(String.t(), String.t()) :: {:ok, String.t()} | {:error, String.t()}
  def lock(org_name, repo_name) do
    GithubClient.put("/repos/#{org_name}/#{repo_name}/branches/master/protection", [], [])
  end
end
