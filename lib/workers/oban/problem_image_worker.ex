defmodule ProblemService.Workers.ProblemImageWorker do
  require Logger
  alias ProblemService.Web.Endpoint
  alias ProblemService.Schema.Problem
  alias ProblemService.Repo

  use Oban.Worker,
    queue: :default,
    max_attempts: 5

  @impl Oban.Worker
  def perform(%Oban.Job{args: %{"problem_id" => id, "user_id" => user_id}}) do
    Logger.debug("Broadcasting problem:image:creating for user#{id}")
    problem = Repo.get(Problem, id)
    Endpoint.broadcast!("user:#{user_id}", "problem:image:creating", %{id: id})

    with {:ok, meta} <- Ai.ProblemStatementMetaGenerator.execute(problem.overview),
         {:ok, path} <- generate_image(meta["imagery"]),
         {:ok, _} <-
      Repo.update Problem.changeset(problem, %{img: path}) do
        Endpoint.broadcast!("user:#{user_id}", "problem:image:complete", %{id: id})
      else
        error ->
          Endpoint.broadcast!("user:#{user_id}", "problem:image:error", %{id: id})
          Logger.error("Error: #{inspect(error)}")
      end

    Logger.debug("Generating problem statement for #{id}")
  end

  def perform(%Oban.Job{args: args}) do
    Logger.error("Missed #{inspect(args)}")
  end

  def generate_image(keywords) do
    id = Ecto.UUID.generate()
    path = "/problems/#{id}.png"

    with {:ok, image} <-
           OpenAI.images_generations(
             [
               prompt:
                 "A detailed, colorful image of: #{keywords}. NO FONTS OR TEXT. ONLY IMAGES!!!",
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
