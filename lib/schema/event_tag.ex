defmodule EventService.Schema.EventTag do
  use Ecto.Schema
  import Ecto.Changeset
  alias EventService.Schema
  alias EventService.Schema.EventTag

  schema "event_tags" do
    belongs_to :event, Schema.Event
    belongs_to :tag, Schema.Tag
  end


  @doc false
  def changeset(attrs), do: changeset(%EventTag{}, attrs)

  @doc false
  def changeset(event_tag, attrs) do
    event_tag
    |> cast(attrs, [:event_id, :tag_id])
    |> validate_required([:event_id, :tag_id])
  end
end
