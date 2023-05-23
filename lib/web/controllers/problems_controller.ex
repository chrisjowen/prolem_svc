defmodule ProblemService.ProblemsController do
  use ProblemService.BaseController
  alias ProblemService.ProblemRepo
  alias ProblemService.Schema.Problem

  def create(conn, params) do
    with {:ok, problem} <- ProblemRepo.insert(params) do
      json(conn, problem)
    end
  end

  def update(conn, %{"id" => id} = params) do
    with problem <- ProblemRepo.get(id),
         {:ok, problem} <- ProblemRepo.update(problem, params) do
      json(conn, problem)
    end
  end

  def delete(conn, %{"id" => id}) do
    ProblemRepo.delete!(id)
    json(conn, %{ok: id})
  end

  def submit(conn, %{"problem" => problem, "identifer" => identifer, "sector_id" => sector_id}) do
    params = %{
      problem: problem,
      user_id: current_resource(conn).id,
      sector_id: sector_id,
      identifier: identifer
    }

    with {:ok, problem} <- Que.add(ProblemService.Workers.ProblemCurationWorker, params) do
      json(conn, :ok)
    end
  end
end
