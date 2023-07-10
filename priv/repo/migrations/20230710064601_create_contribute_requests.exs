defmodule ProblemService.Repo.Migrations.CreateContributeRequests do
  use Ecto.Migration

  def change do
    create table(:contribute_requests) do
      add :capacity, :string
      add :message, :text
      add :user_id, references(:users, on_delete: :nothing)
      add :problem_id, references(:problems, on_delete: :nothing)

      timestamps()
    end

    create index(:contribute_requests, [:user_id])
    create index(:contribute_requests, [:problem_id])
  end
end
