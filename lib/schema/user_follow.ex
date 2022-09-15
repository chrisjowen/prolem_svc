defmodule Totem.Schema.UserFollow do
  use Ecto.Schema
  import Ecto.Changeset
  alias Totem.Schema

  schema "user_follows" do
    field :relationship, :string, default: "Friend"
    belongs_to :user, Schema.User
    belongs_to :to, Schema.User
    timestamps()
  end

  @doc false
  def changeset(user_follow, attrs) do
    user_follow
    |> cast(attrs, [:relationship, :user_id, :to_id])
    |> validate_required([:relationship, :user_id, :to_id])
  end
end
