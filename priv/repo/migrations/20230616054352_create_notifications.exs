defmodule ProblemService.Repo.Migrations.CreateNotifications do
  use Ecto.Migration

  def change do
    create table(:notifications) do
      add :type, :string, null: false
      add :actions, {:array, :map}, null: false
      add :content, :string, null: false
      add :title, :string, null: false
      add :read, :boolean, default: false, null: false
      add :to_id, references(:users, on_delete: :nothing)
       timestamps()
    end

    create index(:notifications, [:to_id])
  end
end
