defmodule ProblemService.Repo.Migrations.UpdateIdeaAddEstimatedTimescale do
  use Ecto.Migration

  def change do
    create table(:idea_sectors) do
      add :idea_id, references(:ideas, on_delete: :nothing)
      add :sector_id, references(:sectors, on_delete: :nothing)
    end

    create index(:idea_sectors, [:idea_id])
    create index(:idea_sectors, [:sector_id])
  end
  end
end
