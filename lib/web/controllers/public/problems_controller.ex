defmodule ProblemService.Public.ProblemsController do
  use ProblemService.BaseController
  alias ProblemService.ProblemRepo
  alias ProblemService.Schema.Problem

  def list(conn, params) do
    conn |> json(ProblemRepo.search(params, [:sector]))
  end

  def create(conn, params) do
    with {:ok, problem} <- ProblemRepo.insert(params) do
      json(conn, problem)
    end
  end

  def update(conn, %{"id" => id} = params) do
    with {:ok, problem} <- ProblemRepo.one(params),
         {:ok, problem} <- ProblemRepo.update(problem, params) do
      json(conn, problem)
    end
  end

  def show(conn, %{"id" => id} =params) do
    json(conn, ProblemRepo.get(id,  [:sector, :followers, :user]))
  end

  def submit(conn, %{"problem" => problem, "identifer" => identifer, "sector_id" => sector_id}) do
    with {:ok, problem} <-
           Que.add(
             ProblemService.Workers.ProblemCurationWorker,
             %{
               problem: problem,
               user_id: 1,
               sector_id: sector_id,
               identifier: identifer
             }
           ) do
      json(conn, :ok)
    end
  end
end
