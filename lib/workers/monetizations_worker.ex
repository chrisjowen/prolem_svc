defmodule ProblemService.Workers.MonetizationsWorker do
  use Que.Worker
  alias ProblemService.Web.Endpoint
  alias ProblemService.ProblemRepo
  alias ProblemService.SolutionRepo

  def perform(%{
        problem_id: problem_id,
        solution_id: solution_id,
        user_id: user_id,
        identifier: identifier
      }) do
    with problem <- ProblemRepo.get(problem_id),
         solution <- SolutionRepo.get(solution_id),
         {:ok, result} <- Openai.Monetization.generate(problem.overview, solution.description) do
      Enum.each(result["monetization"], fn monetization ->
        ProblemService.MonetizationRepo.insert!(
          Map.merge(
            monetization,
            %{
              "problem_id" => problem.id,
              "solution_id" => solution.id,
              "user_id" => user_id
            }
          )
        )
      end)

      Endpoint.broadcast("problem:id-#{problem.id}", "added:monetization", %{
        problem_id: problem.id
      })
    end
  end
end
