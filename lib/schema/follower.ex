defmodule ProblemService.Schema.Follower do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query

  schema "problem_followers" do
    belongs_to :user, ProblemService.Schema.User
    belongs_to :problem, ProblemService.Schema.Problem
  end

  @doc false

  def changeset(user, attrs) do
    required = [:user_id, :problem_id]
    additional = []

    user
    |> cast(attrs, required ++ additional)
    |> validate_required(required)
  end


  def by_problem(problem_id) do
    from(f in ProblemService.Schema.Follower, where: f.problem_id == ^problem_id)
  end
end
