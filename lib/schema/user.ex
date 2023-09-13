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
    field :type, :string, default: "human"
    field :profile_pic, :string
    field :username, :string
    field :tagline, :string
    field :ext_id, :string
    field :ext_ref, :string
    field :clear_password, :string, virtual: true
    has_many :problems, ProblemService.Schema.Problem
    has_many :memberships, ProblemService.Schema.ProblemUser, foreign_key: :member_id
    has_one :profile, ProblemService.Schema.UserProfile
    timestamps()
  end

  @doc false

  def changeset(user, attrs) do
    attrs = maybe_add_clear_password(attrs)
    required = [:name, :last_name,  :username]
    additional = [
      :password,
      :salt,
      :profile_pic,
      :type,
      :tagline,
      :ext_id,
      :ext_ref,
      :email,
      :clear_password
    ]

    user
    |> cast(attrs, required ++ additional)
    |> maybe_validate_password(user, attrs)
    |> maybe_validate_ext_login(user, attrs)
    |> validate_required(required)
  end

  defp maybe_validate_password(changeset, user, attrs) do
    if((user.ext_id == nil && attrs["ext_id"] == nil) ||  attrs["password"] != nil ) do
      changeset
      |> validate_length(:clear_password, min: 6)
      |> validate_format(
        :clear_password,
        ~r/^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*#?&])[A-Za-z\d@$!%*#?&]{8,}$/,
        message: "must contain at least one uppercase letter, a number and a special character"
      )
      |> validate_required([:password, :salt, :username])
    else
      changeset
    end
  end

  defp maybe_validate_ext_login(changeset, user, attrs) do
    if(user.ext_id != nil || attrs["ext_id"] != nil) do
      changeset
      |> validate_required([:ext_id, :ext_ref])
    else
      changeset
    end
  end


  defp maybe_add_clear_password(%{"password" => password} = attrs) do
    attrs |> Map.put("clear_password", password)
  end
  defp maybe_add_clear_password(attrs), do: attrs



  defmodule Queries do
    import Ecto.Query

    def with_username(user, email) do
      from u in user,
        where: u.email == ^email or u.username == ^email
    end
  end
end
