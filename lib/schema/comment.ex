defmodule ProblemService.Schema.Comment do
  use Ecto.Schema
  import Ecto.Changeset

  schema "comments" do
    field :comment, :string
    belongs_to :user, ProblemService.Schema.User
    belongs_to :solution, ProblemService.Schema.Solution
    belongs_to :problem, ProblemService.Schema.Problem
    timestamps()
  end

  @doc false
  def changeset(comment, attrs) do
    comment
    |> cast(attrs, [:comment, :user_id, :solution_id, :problem_id])
    |> validate_required([:comment, :user_id])
    |> Util.EctoUtil.validate_required_inclusion([:solution_id, :problem_id])
  end


end
