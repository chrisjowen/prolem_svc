defmodule ProblemService.Repo.Migrations.CreateLinks do
  use Ecto.Migration

  def change do
    create table(:links) do
      add :url, :string
      add :text, :string
      add :icon, :string
      add :screenshot, :string
      add :description, :string
      add :problem_id, references(:problems, on_delete: :nothing)
      add :solution_id, references(:solutions, on_delete: :nothing)
      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create index(:links, [:problem_id])
    create index(:links, [:solution_id])
    create index(:links, [:user_id])
  end
end
