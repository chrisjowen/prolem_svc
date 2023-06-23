defmodule ProblemService.Schema.ProblemUser do
  use Ecto.Schema
  import Ecto.Changeset

  schema "problem_users" do
    field :role, :string
    #  requested, invited, active, declined
    field :status, :string, default: "invited"
    belongs_to :problem, ProblemService.Schema.Problem
    belongs_to :member, ProblemService.Schema.User
    belongs_to :user, ProblemService.Schema.User
    belongs_to :updated_by, ProblemService.Schema.User
  end

  @doc false
  def changeset(problem_user, attrs) do
    required = [:role, :problem_id, :member_id, :user_id]
    additional = [:updated_by_id, :status]

    problem_user
    |> cast(attrs, required ++ additional)
    |> validate_required(required)
  end

  def authorize(:create, user, %{params: %{"status" => "requested"}, problem: problem}) do
    problem.public
  end

  def authorize(:update, user, %{problem: problem, member: %{status: "invited"} = member}) do
    member.member_id == user.id
  end

  def authorize(:delete, user, %{problem: problem, member: member}) do
    is_owner(problem, user) || is_admin(problem.problem_users, user) ||
      user.id == member.member_id
  end

  def authorize(mode, user, %{problem: problem}) when mode in [:create, :update] do
    is_owner(problem, user) || is_admin(problem.problem_users, user)
  end

  defp is_owner(problem, user) do
    problem.user_id == user.id
  end

  defp is_admin(members, user) do
    members
    |> Enum.any?(fn problem_user ->
      problem_user.role == "admin" && problem_user.member_id == user.id
    end)
  end
end
