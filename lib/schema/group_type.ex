defmodule Totem.Schema.GroupType do
  use Ecto.Schema
  import Ecto.Changeset

  schema "group_types" do
    field :name, :string
    timestamps()
  end

  @doc false
  def changeset(group_type, attrs) do
    group_type
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
