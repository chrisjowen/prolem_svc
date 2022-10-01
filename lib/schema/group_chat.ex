defmodule Totem.Schema.GroupChat do
  use Ecto.Schema
  alias Totem.Schema
  import Ecto.Changeset

  schema "group_chats" do
    field :msg, :string
    belongs_to :group, Schema.Group
    belongs_to :user, Schema.User
    belongs_to :media, Schema.GroupMedia, type: Ecto.UUID

    timestamps()
  end

  @doc false
  def changeset(event_chat, attrs) do
    event_chat
    |> cast(attrs, [:msg, :media_id, :user_id, :group_id])
    |> validate_required([ :user_id, :group_id])
  end
end
