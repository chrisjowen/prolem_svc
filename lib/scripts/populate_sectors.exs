alias Que
alias ProblemService.SectorRepo

sector_names = SectorRepo.all()
      |> Enum.map(fn sector -> sector.name end)


sectors =
  (File.cwd!() <> "/resources/sectors.txt")
  |> File.read!()
  |> String.split("\n")
  |> Enum.uniq()
  |> Enum.filter(fn sector -> sector not in sector_names end)
  |> Enum.each(fn sector ->
    Que.add(ProblemService.Workers.SectorWorker, sector)
  end)
