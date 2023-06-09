# defmodule ProblemService.Workers.SectorImageWorker do
#   use Que.Worker, concurrency: 10

#   alias ProblemService.Web.Endpoint
#   alias ProblemService.SectorRepo

#   def perform(id) do
#     sector = ProblemService.SectorRepo.get(id)

#     with {:ok, result} <- Openai.ImageDescribe.execute(sector.description),
#          {:ok, image} <- make_image(List.first(result["imagery"])),
#          {:ok, path} <- save_image(List.first(image.data)["url"], sector) do
#       SectorRepo.update!(sector, %{image: "/sectors/#{sector.id}.png"})
#     end
#   end

#   def make_image(keywords) do
#     OpenAI.images_generations(
#       [prompt: "A ink sketch of: #{keywords}. NO FONTS OR TEXT. ONLY IMAGES!!!. A hint of colour with hex #164e63", size: "512x512"],
#       %OpenAI.Config{http_options: [recv_timeout: 10 * 60 * 1000]}
#     )
#   end

#   def save_image(url, sector) do
#     path =  "sectors/#{sector.id}.png"

#    with %HTTPoison.Response{body: body} <- HTTPoison.get! url do
#         File.write!(File.cwd! <> "/resources/images/#{path}", body)
#         {:ok, path}
#       end
#   end
# end
