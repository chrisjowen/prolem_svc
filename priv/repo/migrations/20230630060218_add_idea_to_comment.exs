defmodule ProblemService.Repo.Migrations.AddIdeaToComment do
  use Ecto.Migration

  def change do
    alter table(:comments) do
      add :idea_id, references(:ideas, on_delete: :nothing)
    end

    create index(:comments, [:idea_id])

  end
end
