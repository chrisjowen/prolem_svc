defmodule Totem.Schema.UserFriendRequest do
  use Ecto.Schema
  import Ecto.Changeset
  alias Totem.Schema

  schema "user_friend_requests" do
    field :status, :string, default: "OPEN"
    belongs_to :user, Schema.User
    belongs_to :to, Schema.User
    timestamps()
  end

  @doc false
  def changeset(user_friend_request, attrs) do
    user_friend_request
    |> cast(attrs, [:status, :user_id, :to_id])
    |> validate_required([:status, :user_id, :to_id])
  end
end
