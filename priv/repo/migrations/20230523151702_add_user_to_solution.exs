defmodule ProblemService.Repo.Migrations.AddUserToSolution do
  use Ecto.Migration

  def change do
    alter table(:solutions) do
      add :user_id, references(:users, on_delete: :nothing), default: 1
    end

    create index(:solutions, [:user_id])
  end
end
