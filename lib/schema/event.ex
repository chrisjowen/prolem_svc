defmodule Totem.EventMedia do
  use Waffle.Definition
  use Waffle.Ecto.Definition

  @versions [:original, :thumb]

  def storage_dir(version, {_file, scope}) do
    IO.inspect(scope)
    "uploads/event/#{scope.ref}/#{version}"
  end

  def filename(version, {_file, scope}) do
    version
  end

  def transform(:thumb, _) do
    {:convert, "-strip -thumbnail 150x150^ -gravity center -extent 150x150"}
  end

  def transform(:mid, _) do
    {:convert, "-strip -thumbnail 350x350^ -gravity center -extent 350x350"}
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

    # belongs_to :user, Schema.User

    timestamps()
  end

  @doc false
  def changeset(event, attrs) do
    attrs = Map.put(attrs ,"ref", Ecto.UUID.generate())
    event
    |> cast(attrs, [:ref, :url, :provider, :title, :description, :location, :start, :end, :place_id])
    |> cast_attachments(attrs, [:banner])
    |> validate_required([:title, :description, :location, :start, :end])
  end
end
