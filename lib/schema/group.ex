defmodule Totem.Schema.Group do
  use Ecto.Schema
  import Ecto.Changeset
  alias Totem.Schema

  schema "groups" do
    field :banner, :string
    field :start, :naive_datetime
    field :title, :string
    field :description, :string
    belongs_to :type, GroupType

    field :location, Geo.PostGIS.Geometry
    belongs_to :user, Schema.User
    has_many :group_tags, Schema.GroupTag
    has_many :tags, through: [:group_tags, :tag]
    has_many :chats, Schema.GroupChat
    has_many :media, Schema.GroupMedia

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
      |> cast(attrs, [:title, :start,  :banner, :location, :user_id, :type_id])
      |> validate_required([:title, :start, :location, :user_id])
  end
end
