defmodule Totem.Media do
  use Waffle.Definition
  use Waffle.Ecto.Definition

  @versions [:original, :thumb]

  def storage_dir(version, {_file, scope}) do
    "uploads/#{scope.group_id}/#{version}"
  end

  def filename(_, {_file, scope}) do
    scope.id
  end

  def transform(:thumb, _) do
    {:convert, "-strip -thumbnail 150x150^ -gravity center -extent 150x150"}
  end

  def transform(:mid, _) do
    {:convert, "-strip -thumbnail 350x350^ -gravity center -extent 350x350"}
  end

end

defmodule Totem.Schema.GroupMedia do
  use Ecto.Schema
  use Waffle.Ecto.Schema
  alias Totem.Schema

  import Ecto.Changeset

  @primary_key {:id, Ecto.UUID, autogenerate: true}
  schema "group_media" do
    belongs_to :group, Schema.Group
    belongs_to :user, Schema.User
    field :type, :string
    field :media, Totem.Media.Type
    timestamps()
  end

  @doc false
  def changeset(event_chat, attrs) do
    attrs = Map.put(attrs ,"id", Ecto.UUID.generate())

    event_chat
    |> cast(attrs, [:id, :type, :user_id, :group_id])
    |> cast_attachments(attrs, [:media])
    |> validate_required([:type, :media, :user_id, :group_id])
  end
end
