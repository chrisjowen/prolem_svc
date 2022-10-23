defmodule Totem.Schema.EventDate do
  use Ecto.Schema
  import Ecto.Changeset
  alias Totem.Schema

  schema "event_dates" do
    field :end, :utc_datetime
    field :start, :utc_datetime
    belongs_to :event, Schema.Event
  end

  @doc false
  def changeset(attrs), do: changeset(%Schema.EventDate{}, attrs)

  @doc false
  def changeset(event_date, attrs) do
    event_date
    |> cast(attrs, [:start, :end, :event_id])
    |> validate_required([:start, :end, :event_id])
  end
end
