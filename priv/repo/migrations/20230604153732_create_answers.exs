defmodule ProblemService.Repo.Migrations.CreateAnswers do
  use Ecto.Migration

  def change do
    create table(:answers) do
      add :answer, :text
      add :discussion_id, references(:discussions, on_delete: :nothing)
      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create index(:answers, [:discussion_id])
    create index(:answers, [:user_id])
  end
end
