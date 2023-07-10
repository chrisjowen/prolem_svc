defmodule ProblemService.ProblemController do
  use ProblemService.BaseController, schema: ProblemService.Schema.Problem
  # plug :check_permission when action in [:update, :delete]
  alias ProblemService.Schema.Problem

  @excluded_fields [
    {ProblemService.Schema.Sector, [:description]},
    {ProblemService.Schema.Problem, [:overview]}
  ]

  def create(conn, %{"sector_ids" => sector_ids} = params) do
    with {:ok, problem} <-
           %ProblemService.Schema.Problem{}
           |> ProblemService.Schema.Problem.changeset(params)
           |> Repo.insert() do
      Enum.each(sector_ids, fn sector_id ->
        Repo.insert(%ProblemService.Schema.ProblemSector{
          problem_id: problem.id,
          sector_id: sector_id
        })
      end)

      ProblemService.Workers.ProblemCreationWorker.new(%{
        "problem_id" => problem.id,
        "user_id" => current_resource(conn).id
      })
      |> Oban.insert()

      json(conn, problem)
    end
  end

  def index(conn, params) do

    sector_ids = Map.get(params, "sectors", "")
    |> String.split(",")
    |> Enum.filter(&(&1 != ""))
    |> Enum.map(&String.to_integer/1)
    |> IO.inspect()

    search(conn, params)
    |> Problem.with_sectors(sector_ids)
    |> paginate(conn, params)
  end

  @spec check_permission(Plug.Conn.t(), any) :: {:error, any} | Plug.Conn.t()
  def check_permission(conn, _) do
    problem =
      Repo.get(ProblemService.Schema.Problem, conn.params["id"]) |> Repo.preload(:problem_users)

    with :ok <-
           Bodyguard.permit(
             ProblemService.Schema.Problem,
             :create,
             current_resource(conn),
             problem
           ) do
      conn
    end
  end
end
