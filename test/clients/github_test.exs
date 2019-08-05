defmodule RepoLocker.Clients.GithubTest do
  use ExUnit.Case, async: true

  alias RepoLocker.Clients.Github

  test "lock settings" do
    assert Github.lock_settings() == %{
             enforce_admins: true,
             required_pull_request_reviews: %{
               dismiss_stale_reviews: false,
               require_code_owner_reviews: false,
               required_approving_review_count: 1
             }
           }
  end
end