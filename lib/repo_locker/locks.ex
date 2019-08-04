defmodule RepoLocker.Locks do
  @typedoc """
    Represents a more simple representation for locks around a repository
  """
  @enforce_keys [:branch, :enforce_admins, :require_code_owner_reviews, :repo]
  defstruct [:branch, :enforce_admins, :require_code_owner_reviews, :repo, :restrictions]
  
  @type t :: %RepoLocker.Locks{
    branch: string,
    enforce_admins: boolean,
    repo: string,
    require_code_owner_reviews: boolean,
    restrictions: map
  }
end