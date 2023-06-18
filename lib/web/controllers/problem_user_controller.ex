defmodule ProblemService.ProblemUserController do
  use ProblemService.BaseController, schema: ProblemService.Schema.ProblemUser, add_user: false
  alias ProblemService.Schema.Problem
  alias ProblemService.Schema.ProblemUser

  plug :check_permission when action in [:create, :update, :delete]
  plug ProblemService.SetQuery, only: [:index, :show]
  plug ProblemService.ClearOrderBy, only: [:index, :show]

  def check_permission(conn, _) do
    problem = Repo.get(Problem, conn.params["problem_id"]) |> Repo.preload(:problem_users)

    member = case conn.params["id"] do
      nil -> nil
      id -> Repo.get(ProblemUser, id)
    end

    with :ok <-
           Bodyguard.permit(
             ProblemService.Schema.ProblemUser,
             Phoenix.Controller.action_name(conn),
             current_resource(conn),
             %{problem: problem, params: conn.params, member: member }
           ) do
      conn
    end
  end
end
