defmodule ProblemService.Public.ProblemSolutionController do
  use ProblemService.BaseController
  alias ProblemService.SolutionRepo

  def list(conn, %{"problem_id" => problem_id}) do
    with {:ok, solution} <- SolutionRepo.for_problem(problem_id) do
      json(conn, solution)
    end
  end
end
