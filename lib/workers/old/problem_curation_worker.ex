# defmodule ProblemService.Workers.ProblemCurationWorker do
#   use Que.Worker, concurrency: 50
#   alias ProblemService.Web.Endpoint
#   alias ProblemService.ProblemRepo

#   def perform(%{sector_id: sector_id, problem: raw, user_id: user_id, identifier: identifier}) do
#     sector = ProblemService.SectorRepo.get(sector_id)
#     with {:ok, statement} <- Openai.Statement.generate(raw, sector),
#          {:ok, %{"title" => title, "blurb" => blurb}} <- Openai.Title.generate(statement),
#          #  {:ok, image} <- Openai.Image.generate("Banner image for problem: #{blurb}"),
#          {:ok, problem} <-
#            ProblemRepo.insert(%{
#             sector_id: sector_id,
#              title: title,
#              blurb: blurb,
#              overview: statement,
#              user_id: user_id,
#              slug: title |> String.downcase() |> String.replace(" ", "_")
#            }) do
#       enqueue_workers(problem, user_id, identifier)
#       Endpoint.broadcast("problem:uid-#{identifier}", "created:problem", %{problem_id: problem.id})
#     end
#   end

#   def enqueue_workers(problem, user_id, identifier) do
#     params = %{
#       problem_id: problem.id,
#       user_id: user_id,
#       identifier: identifier
#     }
#     [
#       ProblemService.Workers.ProblemImageWorker,
#       ProblemService.Workers.SimilarProductsWorker,
#       ProblemService.Workers.StakeholdersWorker,
#       ProblemService.Workers.SolutionWorker
#     ]
#     |> Enum.each(&Que.add(&1, params))
#   end
# end