defmodule Totem.Schema.Group do
  use Ecto.Schema
  import Ecto.Changeset
  alias Totem.Schema

  schema "groups" do
    field :banner, :string
    field :start, :naive_datetime
    field :title, :string
    field :description, :string
    field :place_id, :string
    field :place_name, :string
    field :place_address, :string
    field :distance, :string, virtual: true


    belongs_to :type, Schema.GroupType

    field :location, Geo.PostGIS.Geometry
    belongs_to :user, Schema.User
    has_many :group_tags, Schema.GroupTag
    has_many :tags, through: [:group_tags, :tag]
    has_many :chats, Schema.GroupChat
    has_many :media, Schema.GroupMedia
    has_many :group_members, Schema.GroupMember
    has_many :members,  through: [:group_members, :user]

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
    required = [
      :title,
      :start,
      :location,
      :user_id,
      :type_id
    ]

    all =
      [
        :banner,
        :place_id,
        :place_name,
        :place_address
      ] ++ required

    event
    |> cast(attrs, all)
    |> validate_required(required)
  end
end
