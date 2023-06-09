defmodule ProblemService.Workers.CreateProblemSuggestionsWorker do
  use Que.Worker, concurrency: 50
  alias ProblemService.Web.Endpoint
  alias ProblemService.Repo
  alias ProblemService.Schema.Sector
  alias ProblemService.Schema.ProblemSuggestion
  require Logger

  def perform(filter \\ []) do
    # TODO: Im allowing myself to do EVERYTHING here, change to workflow later
    filter =  filter |> Enum.filter(&(&1 != ""))
    sectors =
      case({filter, Repo.all(Sector)}) do
        {[], sectors} -> sectors
        {filters, sectors} -> sectors |> Enum.filter(&(&1.id in filters))
      end

    # Enum.each(sectors, &create_problem_suggestions/1)
    Enum.each(sectors, fn sector -> Task.async(fn -> create_problem_suggestions(sector) end) end)
  end

  defp create_problem_suggestions(sector) do
    with {:ok, response} <- Ai.ProblemSuggestionGenerator.execute(sector.name) do
      response["suggestions"]
      |> Enum.each(fn suggestion ->
        Logger.info("Creating problem suggestion: #{suggestion["title"]}")
        save_problem_suggestion(suggestion, sector)
      end)
    end
  end

  defp save_problem_suggestion(suggestion, sector) do
    ProblemSuggestion.changeset(%ProblemSuggestion{}, %{
      sector_id: sector.id,
      title: suggestion["title"],
      blurb: suggestion["blurb"]
    })
    |> Repo.insert()
  end
end
