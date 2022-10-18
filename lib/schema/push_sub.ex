defmodule Totem.Schema.PushSub do
  use Ecto.Schema
  import Ecto.Changeset
  alias Totem.Schema

  schema "push_sub" do
    field :endpoint, :string
    belongs_to :user, Schema.User

    timestamps()
  end

  @doc false
  def changeset(push_sub, attrs) do
    push_sub
    |> cast(attrs, [:user_id, :endpoint])
    |> validate_required([:user_id, :endpoint])
  end
end
