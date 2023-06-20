defmodule ProblemService.Workers.SectorCreateWorker do
  use Que.Worker, concurrency: 10

  alias ProblemService.Schema.Sector
  alias ProblemService.Repo

  def perform(name) do
    with {:ok, description} <- Ai.SectorDescriptionGenerator.execute(name),
         {:ok, result} <- Ai.ImageryGenerator.execute(name),
         {:ok, image} <- generate_image(result["imagery"]) do
          Sector.changeset(%Sector{}, %{
            name: name,
            description: description,
            image: image,
          })
          |> Repo.insert()
    else
      {:error, reason} ->
        IO.inspect(reason)
    end
  end


  def generate_image(keywords) do
    id = Ecto.UUID.generate()
    path = "/sectors/#{id}.png"

    with {:ok, image} <-
           OpenAI.images_generations(
             [
               prompt: "A colorful pencil & ink sketch of: #{keywords}. NO FONTS OR TEXT. ONLY IMAGES!!!",
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
