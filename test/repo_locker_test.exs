defmodule RepoLockerTest do
  use ExUnit.Case

  describe "lock" do
    test "sets permissions on master branch and returns locks" do
      {:ok, lock} = RepoLocker.lock('owner-name', 'repo-name')
      
      assert lock == %RepoLocker.Locks{
        branch: "master",
        enforce_admins: true,
        require_code_owner_reviews: false,
        repo: "repo-name",
        restrictions: %{
          teams: ["owner-name"],
          users: ["owner-name"]
        }
      }
    end
1
    test "returns a message when failing" do
      {:error, msg} = RepoLocker.lock('bad-owner', 'repo-name')
      assert msg = "fail"
    end
  end
end
