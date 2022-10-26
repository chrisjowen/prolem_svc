defmodule Totem.Schema.Credential do
  use Ecto.Schema
  import Ecto.Changeset
  alias Totem.Schema

  schema "credentials" do
    field :username, :string
    field :password, :string
    field :salt, :string
    field :token, :string
    field :ext_ref, :string
    field :provider, :string, default: "Password"
    belongs_to :user, Schema.User
    timestamps()
  end

  @doc false

  @required [
    :user_id,
    :provider
  ]

  def changeset(attrs), do: changeset(%__MODULE__{}, attrs)

  def changeset(credentials, %{"password" => password} = attrs) do
    salt = Randomizer.generate!(40)
    attrs = attrs |> Map.put("salt", salt)
                  |> Map.put("password", encrypt_password(salt,password))

    changeset(credentials, attrs, [
      :username,
      :password,
      :salt
    ])
  end

  def changeset(credentials, %{"token" => _token} = attrs) do
    changeset(credentials, attrs, [
      :token,
      :ext_ref
    ])
  end

  def changeset(credentials, attrs, params) do
    params = params ++ @required

    credentials
    |> cast(attrs, params)
    |> validate_required(params)
  end


  def encrypt_password(salt, password) do
    sha = :crypto.hash_init(:sha256)
    sha = :crypto.hash_update(sha, salt)
    sha = :crypto.hash_update(sha, password)
    sha_binary = :crypto.hash_final(sha)
    sha_binary |> Base.encode16 |> String.downcase
  end

  def check_password(credential, password) do
    IO.inspect(credential.password )
    IO.inspect(encrypt_password(credential.salt, password))
    IO.inspect(credential.salt)
    IO.inspect(password)
    credential.password == encrypt_password(credential.salt, password)
  end

end
