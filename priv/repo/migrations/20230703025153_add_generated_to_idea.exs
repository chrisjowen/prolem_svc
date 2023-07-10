defmodule ProblemService.Repo.Migrations.AddGeneratedToIdea do
  use Ecto.Migration

  def change do
    alter table(:ideas) do
      add :generated, :boolean, nil: false, default: true
      add :user_id, references(:users, on_delete: :nothing)

    end

    create index(:ideas, [:user_id])
  end
end
