defmodule RepoLocker.Locks do
  @moduledoc false
  @typedoc """
    Represents a more simple representation for locks around a repository
  """
  @enforce_keys [:branch, :enforce_admins, :require_code_owner_reviews, :repo]
  defstruct [:branch, :enforce_admins, :require_code_owner_reviews, :repo, :restrictions]

  @type t :: %RepoLocker.Locks{
          branch: String.t(),
          enforce_admins: boolean,
          repo: String.t(),
          require_code_owner_reviews: boolean,
          restrictions: map
        }
end
