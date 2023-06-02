# defmodule ProblemService.Workers.IdeaGeneratorWorker do
#   use Que.Worker, concurrency: 50
#   alias ProblemService.IdeaRepo
#   alias ProblemService.SectorRepo

#   def perform(sector_id) do
#     with sector <- SectorRepo.get(sector_id),
#          {:ok, result} <- Openai.SuggestSectorIdeas.execute(sector.name, sector.description) do
#       Enum.each(result["ideas"], fn idea ->
#         IdeaRepo.insert!(%{
#           title: idea["name"],
#           description: idea["description"],
#           sector_id: sector.id
#         })
#       end)
#     else
#       error -> IO.inspect(error)
#     end
#   end
# end
