defmodule ProblemService.Repo.Migrations.AddOthersToComments do
  use Ecto.Migration

  def change do
    alter table(:comments) do
      add :discussion_id, references(:discussions, on_delete: :nothing)
      add :answer_id, references(:answers, on_delete: :nothing)
    end

    create index(:comments, [:discussion_id])
    create index(:comments, [:answer_id])
  end
end
