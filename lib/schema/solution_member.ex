defmodule ProblemService.Schema.SolutionMember do
  use Ecto.Schema
  import Ecto.Changeset

  schema "solution_members" do
    field :role, :string
    belongs_to :user, ProblemService.Schema.User
    belongs_to :solution, ProblemService.Schema.Solution
  end

  @doc false
  def changeset(solution_member, attrs) do
    solution_member
    |> cast(attrs, [:role, :user_id, :solution_id])
    |> validate_required([:role, :user_id, :solution_id])
  end
end
