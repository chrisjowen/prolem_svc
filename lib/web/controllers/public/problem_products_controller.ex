defmodule ProblemService.Public.ProblemProductController do
  use ProblemService.BaseController
  alias ProblemService.ProblemRepo
  alias ProblemService.ProductRepo

  def submit(conn, %{"problem_id" => problem_id}) do
    problem = ProblemRepo.get(problem_id)

    Que.add(
      ProblemService.Workers.SimilarProductsWorker,
      %{
        problem: problem,
        user_id: 1,
      }
    )
    json(conn, :ok)
  end


  def list(conn, %{"problem_id" => problem_id}) do
      json(conn, ProductRepo.all_for_problem(problem_id))
  end

end
