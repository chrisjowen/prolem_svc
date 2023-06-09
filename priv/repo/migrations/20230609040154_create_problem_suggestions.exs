defmodule ProblemService.Repo.Migrations.CreateProblemSuggestions do
  use Ecto.Migration

  def change do
    create table(:problem_suggestions) do
      add :title, :string
      add :blurb, :string
      add :status, :string
      add :used, :boolean, default: false, null: false
      add :sector_id, references(:sectors, on_delete: :nothing)

      timestamps()
    end

    create index(:problem_suggestions, [:sector_id])
  end
end
