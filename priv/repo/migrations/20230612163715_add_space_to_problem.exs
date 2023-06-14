defmodule ProblemService.Repo.Migrations.AddSpaceToProblem do
  use Ecto.Migration

  def change do
    alter table(:problems) do
      add :space_id, references(:spaces, on_delete: :nothing)
    end

    create index(:problems, [:space_id])
  end
end
