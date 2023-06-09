defmodule ProblemService.Repo.Migrations.CreateFollowers do
  use Ecto.Migration

  def change do
    create table(:problem_followers) do
      add :problem_id, references(:problems, on_delete: :nothing)
      add :user_id, references(:users, on_delete: :nothing)
    end
  end
end
