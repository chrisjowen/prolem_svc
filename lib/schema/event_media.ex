defmodule EventService.Media do
  use Waffle.Definition
  use Waffle.Ecto.Definition

  @versions [:original, :thumb]

  def storage_dir(version, {_file, scope}) do
    "uploads/#{scope.event_id}/#{version}"
  end

  def filename(_, {_file, scope}) do
    scope.id
  end

  def transform(:thumb, _) do
    {:convert, "-strip -thumbnail 150x105^ -gravity center -extent 150x150"}
  end

end

defmodule EventService.Schema.EventMedia do
  use Ecto.Schema
  use Waffle.Ecto.Schema
  alias EventService.Schema

  import Ecto.Changeset

  @primary_key {:id, Ecto.UUID, autogenerate: false}
  schema "event_media" do
    belongs_to :event, Schema.Event
    belongs_to :user, Schema.User
    field :type, :string
    field :media, EventService.Media.Type
    timestamps()
  end

  @doc false
  def changeset(event_chat, attrs) do
    attrs = Map.put(attrs ,"id", Ecto.UUID.generate())

    event_chat
    |> cast(attrs, [:id, :type, :user_id, :event_id])
    |> cast_attachments(attrs, [:media])
    |> validate_required([:type, :media, :user_id, :event_id])
  end
end
