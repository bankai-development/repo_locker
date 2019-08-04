defmodule RepoLockerTest do
  use ExUnit.Case

  describe "lock" do
    test "sets permissions on master branch" do
      assert {:ok, "locked!"} == RepoLocker.lock('organization-name', 'repo-name')
    end
  end
end
