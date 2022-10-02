defmodule Totem.Avatar do
  use Waffle.Definition
  use Waffle.Ecto.Definition

  @versions [:original, :thumb]

  def storage_dir(version, {_file, scope}) do
    "uploads/avatars/#{scope.media_id}/#{version}"
  end

  def filename(_, {_file, scope}) do
    scope.id
  end

  def transform(:small, _) do
    {:convert, "-strip -thumbnail 150x150^ -gravity center -extent 150x150"}
  end
end

defmodule Totem.Schema.User do
  use Ecto.Schema
  use Waffle.Ecto.Schema
  import Ecto.Changeset
  alias Totem.Schema

  schema "users" do
    field :name, :string
    field :last_name, :string
    field :email, :string
    field :avatar, Totem.Avatar.Type
    field :avatar_id, Ecto.UUID

    has_many :credentials, Schema.Credential

    field :nickname, :string
    field :nationality, :string
    field :gender, :string
    field :dob, :date

    timestamps()
  end

  @doc false

  def changeset(event, attrs) do
    attrs = Map.put(attrs ,"avatar_id", Ecto.UUID.generate())
    event
    |> cast(attrs, [
      :name,
      :last_name,
      :gender,
      :email,
      :nickname,
      :nationality,
      :gender,
      :dob,
      :avatar_id
    ])
    # |> cast_attachments(event, [:avatar])
    |> validate_required([:name, :last_name, :email, :credentials, :nickname, :avatar_id])
  end
end
