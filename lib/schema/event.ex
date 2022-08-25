defmodule EventService.Schema.Event do
  use Ecto.Schema
  import Ecto.Changeset
  alias EventService.Schema

  schema "events" do
    field :banner, :string
    field :end, :naive_datetime
    field :start, :naive_datetime
    field :title, :string
    field :location, Geo.PostGIS.Geometry
    belongs_to :user, Schema.User
    has_many :event_tags, Schema.EventTag
    has_many :tags, through: [:event_tags, :tag]
    has_many :chats, Schema.EventChat
    has_many :media, Schema.EventMedia

    timestamps()
  end

  @doc false
  def changeset(event, %{"location" => %{"lat" => lat, "lng" => lng}} = attrs) do
    attrs = Map.merge(attrs, %{"location" => %Geo.Point{coordinates: {lng, lat}}})
    changeset(event, attrs)
  end

  def changeset(event, %{"tags" => [h | _] = tags} = attrs) when is_integer(h) do
    attrs = Map.merge(attrs, %{"tags" => Enum.map(tags, &%{"tag_id" => &1})})
    changeset(event, attrs)
  end

  def changeset(event, attrs) do
      event
      |> cast(attrs, [:title, :start, :end, :banner, :location, :user_id])
      |> validate_required([:title, :start, :end, :location, :user_id])
  end
end
