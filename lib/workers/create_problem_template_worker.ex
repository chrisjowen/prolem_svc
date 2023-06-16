defmodule ProblemService.Workers.CreateProblemTemplateWorker do
  use Que.Worker, concurrency: 50
  alias ProblemService.Web.Endpoint
  alias ProblemService.Eventing.Repo
  alias ProblemService.Schema.Sector
  alias ProblemService.Schema.Problem
  require Logger

  def perform(%{
        "trace_id" => trace_id,
        "user_id" => user_id,
        "sector_id" => sector_id,
        "statement" => statement
      }) do
    # TODO: Im allowing myself to do EVERYTHING here, change to workflow later
    sector = Repo.get(Sector, sector_id)
    Endpoint.broadcast!("problem:trace:#{trace_id}", "problem:creating", %{})
    with {:ok, full_statement} <- Ai.ProblemStatementGenerator.execute(statement, sector.name),
         {:ok, meta} <- generate_meta(statement, sector, trace_id),
         {:ok, path} <- generate_image(meta["imagery"], trace_id),
         {:ok, problem} <- save_problem(full_statement, sector, meta, user_id, path) do
      Endpoint.broadcast("problem:trace:#{trace_id}", "problem:created", %{
        id: problem.id
      })
    else
      error -> Logger.error("Error: #{inspect(error)}")
    end
  end

  def generate_meta(statement, sector, trace_id) do
    Endpoint.broadcast!("problem:trace:#{trace_id}", "problem:creating:meta", %{})
    Ai.ProblemStatementMetaGenerator.execute(statement, sector.name)
  end

  defp save_problem(statement, sector, meta, user_id, path) do
    Problem.changeset(%Problem{}, %{
      sector_id: sector.id,
      title: meta["title"],
      blurb: meta["blurb"],
      overview: statement,
      user_id: user_id,
      img: "/#{path}",
      slug: create_slug(meta["title"])
    })
    |> Repo.insert()
  end

  def generate_image(keywords, id) do
    Endpoint.broadcast!("problem:trace:#{id}", "problem:creating:image", %{})
    path = "problems/#{id}.png"

    IO.inspect("A ink sketch of: #{keywords}. NO FONTS OR TEXT. ONLY IMAGES!!!")
    with {:ok, image} <-
           OpenAI.images_generations(
             [
               prompt: "A ink sketch of: #{keywords}. NO FONTS OR TEXT. ONLY IMAGES!!!",
               size: "512x512"
             ],
             %OpenAI.Config{http_options: [recv_timeout: 10 * 60 * 1000]}
           ),
         %HTTPoison.Response{body: body} <- HTTPoison.get!(List.first(image.data)["url"]) do
      File.write!(File.cwd!() <> "/resources/images/#{path}", body)
      {:ok, path}
    end
  end

  defp create_slug(title) do
    title |> String.downcase() |> String.replace(" ", "_")
  end
end
