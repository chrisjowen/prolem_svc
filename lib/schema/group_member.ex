defmodule Totem.Schema.GroupMember do
  use Ecto.Schema
  import Ecto.Changeset
  alias Totem.Schema

  schema "group_members" do
    field :is_host, :boolean, default: false
    field :status, :string, default: "JOINED"
    belongs_to :user, Schema.User
    belongs_to :group, Schema.Group
    timestamps()
  end

  @doc false
  def changeset(group_member, attrs) do
    group_member
    |> cast(attrs, [:is_host, :status, :user_id, :group_id])
    |> validate_required([:status, :user_id, :group_id])
  end
end
