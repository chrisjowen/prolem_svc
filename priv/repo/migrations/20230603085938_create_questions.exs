defmodule ProblemService.Repo.Migrations.CreateDiscussions do
  use Ecto.Migration

  def change do
    create table(:discussions) do
      add :title, :string
      add :question, :text
      add :user_id, references(:users, on_delete: :nothing)
      add :solution_id, references(:solutions, on_delete: :nothing)
      add :problem_id, references(:problems, on_delete: :nothing)

      timestamps()
    end

    create index(:discussions, [:user_id])
    create index(:discussions, [:solution_id])
    create index(:discussions, [:problem_id])
  end
end
