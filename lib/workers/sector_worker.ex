defmodule ProblemService.Workers.SectorWorker do
  use Que.Worker, concurrency: 10

  alias ProblemService.Web.Endpoint
  alias ProblemService.SectorRepo

  def perform(name) do
    IO.inspect("SectorWorker")
    with {:ok, description} <- Openai.SectorDescribe.execute(name) do
      sector = SectorRepo.insert!(%{name: name, description: description["content"]})
      Que.add(ProblemService.Workers.SectorImageWorker, sector.id)
    else
      {:error, reason} ->
        IO.inspect(reason)
    end
  end
end
