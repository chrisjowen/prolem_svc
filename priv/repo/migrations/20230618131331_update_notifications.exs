defmodule ProblemService.Repo.Migrations.UpdateNotifications do
  use Ecto.Migration

  def change do
    alter table(:notifications) do
      add :action, :string, default: "create", null: false
      add :item, :map
      add :by_id, references(:users, on_delete: :nothing)
      remove :actions
    end

    create index(:notifications, [:by_id])
  end
end
