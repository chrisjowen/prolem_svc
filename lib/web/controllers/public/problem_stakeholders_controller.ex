defmodule ProblemService.Public.ProblemStakeholderController do
  use ProblemService.BaseController
  alias ProblemService.StakeholderRepo
  alias ProblemService.ProblemRepo

  def submit(conn, %{"problem_id" => problem_id}) do
    problem = ProblemRepo.get(problem_id)

    Que.add(
      ProblemService.Workers.StakeholdersWorker,
      %{
        problem: problem,
        user_id: 1
      }
    )
    json(conn, :ok)
  end


  def list(conn, %{"problem_id" => problem_id}) do
      json(conn, StakeholderRepo.all_for_problem(problem_id))
  end

end
