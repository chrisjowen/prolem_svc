defmodule Totem.Schema.Event do
  use Ecto.Schema
  import Ecto.Changeset
  alias Totem.Schema

  schema "events" do
    field :banner, Totem.Media.Type
    field :description, :string
    field :end, :naive_datetime
    field :location, Geo.PostGIS.Geometry
    field :place_id, :string
    field :start, :naive_datetime
    field :title, :string
    # belongs_to :user, Schema.User

    timestamps()
  end

  @doc false
  def changeset(event, attrs) do
    event
    |> cast(attrs, [:title, :description, :banner, :location, :start, :end, :place_id])
    |> validate_required([:title, :description, :location, :start, :end])
  end
end
