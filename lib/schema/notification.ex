defmodule Totem.Schema.Notification do
  use Ecto.Schema
  import Ecto.Changeset
  alias Totem.Schema

  schema "notifications" do
    field :actions, {:array, :map}
    field :message, :string
    field :title, :string
    field :type, :string
    field :read, :boolean
    belongs_to :user, Schema.User

    timestamps()
  end

  @doc false
  def changeset(notification, attrs) do
    notification
    |> cast(attrs, [:type, :message, :title, :actions, :user_id])
    |> validate_required([:type, :message, :title, :user_id])
  end
end
