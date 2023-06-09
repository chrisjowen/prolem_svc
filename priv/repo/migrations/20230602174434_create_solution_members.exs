defmodule ProblemService.Repo.Migrations.CreateSolutionMembers do
  use Ecto.Migration

  def change do
    create table(:solution_members) do
      add :role, :string
      add :user_id, references(:users, on_delete: :nothing)
      add :solution, references(:solutions, on_delete: :nothing)
    end

    create index(:solution_members, [:user_id])
    create index(:solution_members, [:solution])
  end
end
