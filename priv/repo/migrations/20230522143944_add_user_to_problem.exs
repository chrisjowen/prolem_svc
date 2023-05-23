defmodule ProblemService.Repo.Migrations.AddUserToProblem do
  use Ecto.Migration

  def change do
    alter table(:problems) do
      add :user_id, references(:users, on_delete: :nothing), default: 1
    end

    create index(:problems, [:user_id])
  end
end
