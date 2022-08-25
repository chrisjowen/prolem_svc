defmodule EventService.Schema.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias EventService.Schema

  schema "users" do
    field :name, :string
    field :last_name, :string
    field :gender, :string
    field :email, :string
    field :profile_pic, :string
    has_many :credentials, Schema.Credential
    timestamps()
  end

  @doc false

  def changeset(event, attrs) do
      event
      |> cast(attrs, [:name, :last_name, :gender, :email, :profile_pic])
      |> validate_required([:name, :last_name])
  end
end
