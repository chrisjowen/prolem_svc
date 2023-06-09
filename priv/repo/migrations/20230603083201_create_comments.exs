defmodule ProblemService.Repo.Migrations.CreateComments do
  use Ecto.Migration

  def change do
    create table(:comments) do
      add :comment, :string
      add :user_id, references(:users, on_delete: :nothing)
      add :solution_id, references(:solutions, on_delete: :nothing)
      add :problem_id, references(:problems, on_delete: :nothing)

      timestamps()
    end

    create index(:comments, [:user_id])
    create index(:comments, [:solution_id])
    create index(:comments, [:problem_id])
  end
end
