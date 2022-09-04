defmodule Totem.Schema.GroupInvite do
  use Ecto.Schema
  import Ecto.Changeset
  alias Totem.Schema

  schema "group_invites" do
    field :status, :string, default: "OPEN"
    belongs_to :user, Schema.User
    belongs_to :to, Schema.User
    belongs_to :group, Schema.Group


    timestamps()
  end

  @doc false
  def changeset(group_invite, attrs) do
    group_invite
    |> cast(attrs, [:status, :user_id, :to_id, :group_id])
    |> validate_required([:status, :user_id, :to_id, :group_id])
  end
end
