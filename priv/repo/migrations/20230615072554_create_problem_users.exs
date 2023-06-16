defmodule ProblemService.Repo.Migrations.CreateProblemUsers do
  use Ecto.Migration

  def change do
    create table(:problem_users) do
      add :role, :string
      add :problem_id, references(:problems, on_delete: :nothing)
      add :member_id, references(:users, on_delete: :nothing)
    end

    create index(:problem_users, [:problem_id])
    create index(:problem_users, [:member_id])
  end
end
