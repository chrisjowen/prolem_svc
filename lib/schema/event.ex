defmodule Totem.EventMedia do
  use Waffle.Definition
  use Waffle.Ecto.Definition

  @versions [:original, :card, :pin]

  def storage_dir(version, {_file, scope}) do
    "uploads/event/#{scope.ref}/#{version}"
  end

  def filename(version, {_file, _scope}) do
    version
  end


  def transform(:card, _) do
    {:convert, "-strip -thumbnail 500x500^ -gravity center -extent 500x500"}
  end

  def transform(:pin, _) do
    {:convert, "-strip -thumbnail 50x50^ -gravity center -extent 50x50"}
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
    field :location, Geo.PostGIS.Geometry
    field :place_id, :string
    field :start, :utc_datetime
    field :end, :utc_datetime

    field :title, :string
    field :ref, Ecto.UUID
    field :url, :string
    field :provider, :string
    field :blurb, :string
    field :tags, {:array, :string}

    field :distance, :decimal, virtual: true
    belongs_to :type, Schema.EventType
    has_many :dates, Schema.EventDate

    timestamps()
  end

  @doc false
  def changeset(event, attrs) do
    attrs = add_ref_if_not_present(event, attrs)
    required = [:title, :description, :provider, :location, :type_id, :ref]
    cast  = required ++ [
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
