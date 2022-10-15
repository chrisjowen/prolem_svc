defmodule Totem.EventMedia do
  use Waffle.Definition
  use Waffle.Ecto.Definition

  @versions [:original, :thumb]

  def storage_dir(version, {_file, scope}) do
    "uploads/event/#{scope.ref}/#{version}"
  end

  def filename(version, {_file, _scope}) do
    version
  end

  def transform(:thumb, _) do
    {:convert, "-strip -thumbnail 150x150^ -gravity center -extent 150x150"}
  end
end

defmodule Totem.Schema.Event do
  use Ecto.Schema
  use Waffle.Ecto.Schema
  import Ecto.Changeset
  alias Totem.Schema

  schema "events" do
    field :banner, Totem.EventMedia.Type
    field :description, :string
    field :end, :naive_datetime
    field :location, Geo.PostGIS.Geometry
    field :place_id, :string
    field :start, :naive_datetime
    field :title, :string
    field :ref, Ecto.UUID
    field :url, :string
    field :provider, :string
    field :blurb, :string
    field :tags, {:array, :string}

    field :distance, :decimal, virtual: true
    belongs_to :type, Schema.EventType

    timestamps()
  end

  @doc false
  def changeset(event, attrs) do
    attrs = add_ref_if_not_present(event, attrs)
    required = [:title, :description, :provider, :location, :type_id, :start, :ref]
    cast  = required ++ [
      :end,
      :url,
      :blurb,
      :tags,
      :place_id
    ]

    event
    |> cast(attrs, cast)
    |> cast_attachments(attrs, [:banner])
    |> validate_required(required)
  end

  def add_ref_if_not_present(event, attrs) do
    case(event) do
      %{ref: r} when not is_nil(r) -> attrs
      _ -> Map.put(attrs, "ref", Ecto.UUID.generate())
    end
  end
end
