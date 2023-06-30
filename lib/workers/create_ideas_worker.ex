defmodule ProblemService.Workers.CreateIdeasWorker do
  use Que.Worker, concurrency: 50
  # alias ProblemService.Web.Endpoint
  alias ProblemService.Repo
  alias ProblemService.Schema.Sector
  alias ProblemService.Schema
  require Logger

  def perform(%{"sector_id" => sector_id}) do
    # TODO: Im allowing myself to do EVERYTHING here, change to workflow later
    sectors = Repo.all(Sector)
    sector = Repo.get!(Sector, sector_id)
    create_ideas(sector, sectors)
  end

  defp create_ideas(sector, sectors) do
    sector_names = sectors |> Enum.map(& &1.name)

    with {:ok, response} <- Ai.IdeaGenerator.execute(sector_names, sector.name) do
      response["suggestions"]
      |> Enum.each(fn suggestion ->
        Logger.info("Found idea: #{suggestion["title"]}")

        sectors =
          Enum.filter(sectors, fn sector ->
            Enum.member?(suggestion["sectors"], sector.name)
          end)

        Que.add(ProblemService.Workers.CreateIdeaWorker, %{
          "suggestion" => suggestion,
          "sectors" => sectors
        })
      end)
    end
  end
end
