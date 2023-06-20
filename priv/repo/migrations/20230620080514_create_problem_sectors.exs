defmodule ProblemService.Repo.Migrations.CreateProblemSectors do
  use Ecto.Migration
  alias ProblemService.Schema.Problem
  alias ProblemService.Schema.ProblemSector
  alias ProblemService.Repo

  def up do
    create table(:problem_sectors) do
      add :problem_id, references(:problems, on_delete: :nothing)
      add :sector_id, references(:sectors, on_delete: :nothing)
    end

    flush()

    Repo.transaction(fn ->
      Problem
      |> Repo.all()
      |> Enum.each(fn problem ->
        ProblemSector.changeset(%ProblemSector{}, %{
          problem_id: problem.id,
          sector_id: problem.sector_id
        })
        |> Repo.insert!()
      end)
    end)

    create index(:problem_sectors, [:problem_id])
    create index(:problem_sectors, [:sector_id])
  end

  def down do
    drop table(:problem_sectors)
  end
end
