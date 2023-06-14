defmodule ProblemService.Repo.Migrations.CreateDiscussionRefernces do
  use Ecto.Migration

  def change do
    create table(:discussion_references) do
      add :notes, :text
      add :discussion_id, references(:discussions, on_delete: :nothing)
      add :link_id, references(:links, on_delete: :nothing)
      add :user_id, references(:users, on_delete: :nothing)
    end

    create index(:discussion_references, [:discussion_id])
    create index(:discussion_references, [:link_id])
    create index(:discussion_references, [:user_id])
  end
end
