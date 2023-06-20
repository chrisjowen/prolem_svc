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
  use Waffle.Ecto.Schema

  schema "users" do
    field :name, :string
    field :last_name, :string
    field :email, :string
    field :password, Comeonin.Ecto.Password
    field :salt, :string, default: Ecto.UUID.generate()

    # field :avatar, ProblemService.Avatar.Type
    # field :avatar_id, Ecto.UUID

    field :username, :string
    field :nationality, :string
    field :gender, :string
    field :dob, :date
    field :clear_password, :string, virtual: true
    has_many :problems, ProblemService.Schema.Problem
    timestamps()
  end

  @doc false

  def changeset(user, attrs) do
    password = attrs["password"]
    attrs =
      if(password != nil) do
        attrs |> Map.put("clear_password", password)
      else
        attrs
      end

    user
    |> cast(attrs, [
      :name,
      :last_name,
      :gender,
      :email,
      :username,
      :nationality,
      :gender,
      :dob,
      :password,
      :salt,
      :clear_password
    ])
    # |> cast_attachments(attrs, [:avatar])
    |> validate_length(:clear_password, min: 6, max: 15)
    |> validate_format(
      :clear_password,
      ~r/^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*#?&])[A-Za-z\d@$!%*#?&]{8,}$/,
      message: "must contain at least one uppercase letter, a number and a special character"
    )
    |> validate_required([:name, :last_name, :email, :password, :salt, :username])
  end

  defmodule Queries do
    import Ecto.Query

    def with_username(user, email) do
      from u in user,
        where: u.email == ^email
    end
  end
end
