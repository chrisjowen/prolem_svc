defmodule ProblemService.Schema.Space do
  use Ecto.Schema
  import Ecto.Changeset

  schema "spaces" do
    field :description, :string
    field :slug, :string
    belongs_to :owner, ProblemService.Schema.User

    timestamps()
  end

  @doc false
  def changeset(space, attrs) do
    space
    |> cast(attrs, [:description, :slug, :owner_id])
    |> validate_required([:description, :slug, :owner_id])
  end
end
