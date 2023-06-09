alias Que
alias ProblemService.SectorRepo

SectorRepo.all()
|> Enum.filter(fn sector ->  sector.id in [9,37]  end)
|> #IO.inspect
|> Enum.each(fn sector ->
  Que.add(ProblemService.Workers.SectorImageWorker, sector.id)
end)
