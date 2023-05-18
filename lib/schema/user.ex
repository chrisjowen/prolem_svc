defmodule ProblemService.Avatar do
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

defmodule ProblemService.Schema.User do
  use Ecto.Schema
  use Waffle.Ecto.Schema
  import Ecto.Changeset
  alias ProblemService.Schema
  use Waffle.Ecto.Schema

  schema "users" do
    field :name, :string
    field :last_name, :string
    field :email, :string
    field :password, :string
    field :salt, :string, default: Ecto.UUID.generate()

    # field :avatar, ProblemService.Avatar.Type
    # field :avatar_id, Ecto.UUID


    field :nickname, :string
    field :nationality, :string
    field :gender, :string
    field :dob, :date

    timestamps()
  end

  @doc false

  def changeset(user, attrs) do
    # attrs = Map.put(attrs ,"avatar_id", Ecto.UUID.generate())
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
      :password,
      :salt
    ])
    # |> cast_attachments(attrs, [:avatar])
    |> validate_required([:name, :last_name, :email, :password, :salt])
  end
end
