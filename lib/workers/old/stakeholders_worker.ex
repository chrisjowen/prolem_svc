# defmodule ProblemService.Workers.StakeholdersWorker do
#   use Que.Worker, concurrency: 10
#   alias ProblemService.Web.Endpoint
#   alias ProblemService.StakeholderRepo
#   alias ProblemService.ProblemRepo

#   def perform(%{problem_id: problem_id, user_id: user_id, identifier: identifier}) do
#     Endpoint.broadcast("problem:#{problem_id}", "ai:stakeholders", %{problem_id: problem_id})

#     with problem <- ProblemRepo.get(problem_id),
#          {:ok, result} <- Openai.Stakeholders.generate(problem.overview) do
#       Enum.map(result["stakeholders"], fn stakeholder ->
#         StakeholderRepo.insert!(
#           Map.merge(
#             stakeholder,
#             %{
#               "problem_id" => problem.id,
#               "user_id" => user_id
#             }
#           )
#         )
#       end)
#       # |> Enum.each(&enqueue_questionaire(&1, problem, user_id, identifier))

#       Endpoint.broadcast("problem:#{problem.id}", "reload:stakeholders", %{ok: :ok})
#     end
#   end

# end
