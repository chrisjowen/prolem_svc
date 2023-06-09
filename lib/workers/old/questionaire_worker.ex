# defmodule ProblemService.Workers.QuestionaireWorker do
#   use Que.Worker
#   alias ProblemService.Web.Endpoint
#   alias ProblemService.StakeholderRepo
#   alias ProblemService.ProblemRepo
#   alias ProblemService.QuestionaireRepo

#   def perform(%{
#         problem_id: problem_id,
#         stakeholder_id: stakeholder_id,
#         user_id: user_id,
#         identifier: identifier
#       }) do
#     Endpoint.broadcast("problem:#{problem_id}", "ai:questionaire", %{problem_id: problem_id})

#     with problem <- ProblemRepo.get(problem_id),
#          stakeholder <- StakeholderRepo.get(stakeholder_id),
#          {:ok, result} <-
#            Openai.Questionaire.generate(
#              problem.overview,
#              "TYPE: #{stakeholder.type}, DESCRIPTION: TYPE: #{stakeholder.description}, PROBLEMS: #{Enum.join(stakeholder.problems, ",")}"
#            ) do
#       params =
#         Map.merge(
#           result,
#           %{
#             "problem_id" => problem.id,
#             "stakeholder_id" => stakeholder.id,
#             "user_id" => user_id
#           }
#         )

#       QuestionaireRepo.insert!(params) |> #IO.inspect()
#       Endpoint.broadcast("problem:#{problem_id}", "reload:questionaire", %{problem_id: problem_id})

#     end
#   end
# end
