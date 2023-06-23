defmodule ProblemService.Repo.Migrations.AddUserIdAndUpdatedByIdToProblemUser do
  use Ecto.Migration

  def change do
    alter table(:problem_users) do
      add :user_id, references(:users, on_delete: :nothing)
      add :updated_by_id, references(:users, on_delete: :nothing)
    end

    create index(:problem_users, [:updated_by_id])
    create index(:problem_users, [:user_id])
  end
end
