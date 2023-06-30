defmodule ProblemService.Workers.CreateIdeaWorker do
  use Que.Worker, concurrency: 50
  # alias ProblemService.Web.Endpoint
  alias ProblemService.Repo
  alias ProblemService.Schema
  require Logger

  def perform(%{"suggestion" => suggestion, "sectors" => sectors}) do
    with {:ok, path} <- generate_image(suggestion["imagery"]),
         {:ok, idea} <- save_suggestion(suggestion, path) do
      Logger.info("Created idea: #{suggestion["title"]}")

      sectors
      |> Enum.map(fn sector ->
        params = %{
          "idea_id" => idea.id,
          "sector_id" => sector.id
        }

        Schema.IdeaSector.changeset(%Schema.IdeaSector{}, params)
        |> Repo.insert!()
      end)
    end
  end

  def save_suggestion(suggestion, path) do
    params = Map.put(suggestion, "img", path)
    Repo.insert(Schema.Idea.changeset(%Schema.Idea{}, params))
  end

  def generate_image(keywords) do
    id = Ecto.UUID.generate()
    path = "/ideas/#{id}.png"

    with {:ok, image} <-
           OpenAI.images_generations(
             [
               prompt:
                 "A detailed, colorful cartoon sketch of: #{keywords}. NO FONTS OR TEXT. ONLY IMAGES!!!",
               size: "512x512"
             ],
             %OpenAI.Config{http_options: [recv_timeout: 10 * 60 * 1000]}
           ),
         %HTTPoison.Response{body: body} <- HTTPoison.get!(List.first(image.data)["url"]) do
      File.write!(File.cwd!() <> "/resources/images#{path}", body)
      {:ok, path}
    end
  end
end
