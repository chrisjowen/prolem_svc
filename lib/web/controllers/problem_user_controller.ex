defmodule ProblemService.ProblemUserController do
  use ProblemService.BaseController, [schema: ProblemService.Schema.ProblemUser, add_user: false]
  alias ProblemService.Schema.Problem

  plug :check_permission when action in [:create, :update, :delete]
  plug ProblemService.SetQuery, only: [:index, :show]
  plug ProblemService.ClearOrderBy, only: [:index, :show]


  def check_permission(conn, _) do
    IO.inspect("conn.params")
    IO.inspect(conn.params)
    problem = Repo.get(Problem, conn.params["problem_id"]) |> Repo.preload(:problem_users)
    with :ok <- Bodyguard.permit(ProblemService.Schema.ProblemUser, :create, current_resource(conn),problem) do
      conn
    end
  end


end
