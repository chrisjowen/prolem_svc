alias Que
alias ProblemService.SectorRepo

SectorRepo.all(ProblemService.Schema.Sector, %{}, [:problems])
|> Enum.filter(fn sector ->  length(sector.problems) == 0  end)
|> Enum.each(fn sector ->
  Que.add(ProblemService.Workers.AutoProblemWorker, sector.id)
end)
