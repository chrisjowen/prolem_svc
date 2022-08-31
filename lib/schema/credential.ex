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

  def changeset(credentials, %{"username" => _u} = attrs) do
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
end
