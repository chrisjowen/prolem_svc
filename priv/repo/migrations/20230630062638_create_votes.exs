defmodule ProblemService.Repo.Migrations.CreateVotes do
  use Ecto.Migration

  def change do
    create table(:votes) do
      add :user_id, references(:users, on_delete: :nothing)
      add :problem_id, references(:problems, on_delete: :nothing)
      add :idea_id, references(:ideas, on_delete: :nothing)

      timestamps()
    end

    create index(:votes, [:user_id])
    create index(:votes, [:problem_id])
    create index(:votes, [:idea_id])
  end
end
