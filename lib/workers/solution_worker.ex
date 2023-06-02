# defmodule ProblemService.Workers.SolutionWorker do
#   use Que.Worker, concurrency: 10
#   alias ProblemService.Web.Endpoint
#   alias ProblemService.SolutionRepo
#   alias ProblemService.ProblemRepo

#   def perform(%{problem_id: problem_id, user_id: user_id, identifier: identifier}) do
#     Endpoint.broadcast("problem:#{problem_id}", "ai:solution", %{problem_id: problem_id})

#     with problem <- ProblemRepo.get(problem_id),
#          {:ok, result} <- Openai.Solution.generate(problem.overview) do
#       params =
#         Map.merge(
#           result["solution"],
#           %{
#             "problem_id" => problem.id,
#             "user_id" => user_id
#           }
#         )

#       solution = SolutionRepo.insert!(params)
#       enqueue_worker(problem, solution, user_id, identifier)

#       Endpoint.broadcast("problem:#{problem.id}", "reload:solution", %{ok: :ok})
#     end
#   end

#   def enqueue_worker(problem, solution, user_id, identifier) do
#     params = %{
#       problem_id: problem.id,
#       solution_id: solution.id,
#       user_id: user_id,
#       identifier: identifier
#     }

#     Que.add(ProblemService.Workers.MonetizationsWorker, params)
#   end
# end
