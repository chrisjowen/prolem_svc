defmodule ProblemService.Repo.Migrations.CreateObstacles do
  use Ecto.Migration

  def change do
    create table(:obstacles) do
      add :description, :text
      add :tags, {:array, :string}
      add :questions, {:array, :text}
      add :hint, :text
      add :problem_id, references(:problems, on_delete: :nothing)

      timestamps()
    end

    create index(:obstacles, [:problem_id])
  end
end
