defmodule ProblemService.Repo.Migrations.AddSectorToProblem do
  use Ecto.Migration

  def change do
    alter table(:problems) do
      add :sector_id, references(:sectors, on_delete: :nothing)
    end
  end
end
