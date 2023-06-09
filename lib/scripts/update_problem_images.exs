alias Que
alias ProblemService.ProblemRepo

ProblemRepo.all()
|> Enum.filter(fn problem -> problem.img == nil end)
|> #IO.inspect
|> Enum.each(fn problem ->
  Que.add(ProblemService.Workers.ProblemImageWorker, problem.id)
end)
