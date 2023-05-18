defmodule ProblemService.Workers.AutoProblemWorker do
  use Que.Worker, concurrency: 50
  alias ProblemService.ProblemRepo
  alias ProblemService.SectorRepo

  def perform(sector_id) do
    with sector <- SectorRepo.get(sector_id),
         {:ok, result} <- Openai.SuggestSectorIdeas.execute(sector.name, sector.description) do

      Enum.each(result["ideas"], fn idea ->

        problem = """
        #{idea["name"]}

        #{idea["description"]}
        """

        Que.add(ProblemService.Workers.ProblemCurationWorker,
           %{sector_id: sector_id, problem: problem, user_id: 1, identifier: "SYSTEM"}
        )
      end)

    else
      error -> IO.inspect(error)
    end
  end
end
