alias Que
alias ProblemService.SectorRepo

SectorRepo.all()
# |> Enum.take(1)
|> Enum.each(fn sector ->
  Que.add(ProblemService.Workers.IdeaGeneratorWorker, sector.id)
end)
