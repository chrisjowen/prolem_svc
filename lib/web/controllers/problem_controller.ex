defmodule ProblemService.ProblemController do
  use ProblemService.BaseController, schema: ProblemService.Schema.Problem
  # plug :check_permission when action in [:update, :delete]


  @excluded_fields [
    {ProblemService.Schema.Sector, [:description]},
    {ProblemService.Schema.Problem, [:overview]},
  ]

  def index(conn, params) do
    searchable_fileds = @excluded_fields ++ Modules.modules()
    result =
      search(conn, params)
      |> Util.MapUtil.from_struct(searchable_fileds)  # TODO: This can be automatically done
    json(conn, result)
  end


  def check_permission(conn, _) do
    problem = Repo.get(ProblemService.Schema.Problem, conn.params["id"]) |> Repo.preload(:problem_users)
    with :ok <- Bodyguard.permit(ProblemService.Schema.Problem, :create, current_resource(conn),problem) do
      conn
    end
  end

end
