defmodule ProblemService.Schema.ProblemUser do
  use Ecto.Schema
  import Ecto.Changeset

  schema "problem_users" do
    field :role, :string
    belongs_to :problem, ProblemService.Schema.Problem
    belongs_to :member, ProblemService.Schema.User
  end

  @doc false
  def changeset(problem_user, attrs) do
    required = [:role, :problem_id, :member_id]

    problem_user
    |> cast(attrs, required)
    |> validate_required(required)
  end

  def authorize(mode, user, problem) when mode in [:create, :update, :delete] do
    is_owner = problem.user_id == user.id
    is_admin =
      problem.problem_users
      |> Enum.any?(fn problem_user ->
        problem_user.role == "admin" && problem_user.member_id == user.id
      end)

    is_owner || is_admin
  end
end
