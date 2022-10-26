defmodule Totem.Avatar do
  use Waffle.Definition
  use Waffle.Ecto.Definition

  @versions [:original]

  def storage_dir(version, {_file, scope}) do
    "uploads/avatars/#{scope.media_id}/#{version}"
  end

  def filename(_, {_file, scope}) do
    scope.id
  end

  def transform(:original, _) do
    {:convert, "-strip -thumbnail 500x500^ -gravity center -extent 500x500"}
  end
end

defmodule Totem.Schema.User do
  use Ecto.Schema
  use Waffle.Ecto.Schema
  import Ecto.Changeset
  alias Totem.Schema
  use Waffle.Ecto.Schema

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

  def changeset(user, attrs) do
    attrs = Map.put(attrs ,"avatar_id", Ecto.UUID.generate())
    user
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
    |> cast_attachments(attrs, [:avatar])
    |> validate_required([:name, :last_name, :email, :credentials, :nickname, :avatar_id])
  end
end
