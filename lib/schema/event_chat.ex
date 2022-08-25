defmodule EventService.Schema.EventChat do
  use Ecto.Schema
  alias EventService.Schema
  import Ecto.Changeset

  schema "event_chats" do
    field :msg, :string
    belongs_to :event, Schema.Event
    belongs_to :user, Schema.User
    belongs_to :media, Schema.EventMedia, type: Ecto.UUID

    timestamps()
  end

  @doc false
  def changeset(event_chat, attrs) do
    event_chat
    |> cast(attrs, [:msg, :media_id, :user_id, :event_id])
    |> validate_required([:msg, :user_id, :event_id])
  end
end
