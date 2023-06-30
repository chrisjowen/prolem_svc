defmodule ProblemService.Workers.CreateStakeholderImageWorker do
  use Que.Worker, concurrency: 10

  alias ProblemService.Schema.Stakeholder
  alias ProblemService.Schema.Problem
  alias ProblemService.Repo

  require Logger

  def perform(%{"stakeholder_id" => stakeholder_id}) do
    Logger.info("Creating image for stakeholder #{stakeholder_id}")

    with stakeholder <- Repo.get(Stakeholder, stakeholder_id),
         {:ok, results} <- Ai.StakeholderImageGenerator.execute(stakeholder),
         {:ok, image} <- generate_image(results) do
      Stakeholder.changeset(stakeholder, %{img: image})
      |> Repo.update!()
    else
      {:error, reason} -> Logger.error("Error creating stakeholders: #{inspect(reason)}")
      unknown -> Logger.error("Error creating stakeholders: #{inspect(unknown)}")
    end
  end

  def generate_image(persona) do
    id = Ecto.UUID.generate()
    path = "/general/#{id}.png"

    prompt =
      "A photo of a #{persona["age"]} year old #{persona["gender"]} of race #{persona["race"]} with features #{persona["features"]  }"

    with {:ok, image} <-
           OpenAI.images_generations(
             [
               prompt: prompt,
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

# {keywords}. NO FONTS OR TEXT. ONLY IMAGES!!!
