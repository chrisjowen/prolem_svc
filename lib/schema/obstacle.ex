defmodule ProblemService.Schema.Obstacle do
  use Ecto.Schema
  import Ecto.Changeset

  schema "obstacles" do
    field :description, :string
    field :hint, :string
    field :questions, {:array, :string}, default: []
    field :tags, {:array, :string}
    belongs_to :problem, ProblemService.Schema.Problem
    timestamps()
  end

  @doc false
  def changeset(obstacle, attrs) do
    obstacle
    |> cast(attrs, [:description, :tags, :questions, :hint, :problem_id])
    |> validate_required([:description, :tags, :questions, :problem_id])
  end
end
