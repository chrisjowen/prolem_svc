defmodule ProblemService.Workers.CreateProblemTemplateWorker do
  use Que.Worker, concurrency: 50
  alias ProblemService.Web.Endpoint
  alias ProblemService.Eventing.Repo
  alias ProblemService.Schema.Sector
  alias ProblemService.Schema.Problem
  alias ProblemService.Schema.ProblemSector
  require Logger

  def perform(%{
        "trace_id" => trace_id,
        "user_id" => user_id,
        "sector_ids" => sector_ids,
        "statement" => statement
      }) do
    sectors =
      Sector
      |> Sector.by_ids(sector_ids)
      |> Repo.all()

    sector_names =
      sectors
      |> Enum.map(fn sector -> sector.name end)
      |> Enum.join(",")

    Endpoint.broadcast!("user:trace:#{trace_id}", "problem:creating", %{})

    with {:ok, full_statement} <- Ai.ProblemStatementGenerator.execute(statement, sector_names),
         {:ok, meta} <- generate_meta(statement, sector_names, trace_id),
         {:ok, path} <- generate_image(meta["imagery"], trace_id),
         {:ok, problem} <- save_problem(full_statement, sectors, meta, user_id, path) do
      Endpoint.broadcast("user:trace:#{trace_id}", "problem:created", %{id: problem.id})
    else
      error -> Logger.error("Error: #{inspect(error)}")
    end
  end

  def generate_meta(statement, sectors_names, trace_id) do
    Endpoint.broadcast!("user:trace:#{trace_id}", "problem:creating:meta", %{})
    Ai.ProblemStatementMetaGenerator.execute(statement, sectors_names)
  end

  defp save_problem(statement, sectors, meta, user_id, path) do
    problem =
      Problem.changeset(%Problem{}, %{
        sector_id: List.first(sectors).id,
        title: meta["title"],
        blurb: meta["blurb"],
        overview: statement,
        user_id: user_id,
        img: "/#{path}",
        slug: create_slug(meta["title"])
      })
      |> Repo.insert!()

    Enum.each(sectors, fn sector ->
      ProblemSector.changeset(%ProblemSector{}, %{sector_id: sector.id, problem_id: problem.id})
      |> Repo.insert!()
    end)

    {:ok, problem}


    # Check: https://elixirforum.com/t/ecto-multi-with-insert-and-insert-all/20649 its down now so not doing multi

    # Ecto.Multi.new()
    # |> Ecto.Multi.insert(:problem, problem_change)
    # |> Ecto.Multi.run(:insert_sectors, fn %{problem: problem} ->
    #   problem_sectors = Enum.map(sectors, fn sectors ->
    #     %ProblemSector{sector_id: sectors.id, problem_id: problem.id}
    #   end)
    #   Ecto.Multi.insert_all(:problem_sectors, problem_sectors)
    # end)
    # |> Repo.transaction()
  end

  def generate_image(keywords, id) do
    Endpoint.broadcast!("problem:trace:#{id}", "problem:creating:image", %{})
    path = "problems/#{id}.png"


    with {:ok, image} <-
           OpenAI.images_generations(
             [
               prompt: "A detailed, colorful cartoon sketch of: #{keywords}. NO FONTS OR TEXT. ONLY IMAGES!!!",
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
