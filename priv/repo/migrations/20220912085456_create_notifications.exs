defmodule Totem.Repo.Migrations.CreateNotifications do
  use Ecto.Migration

  def change do
    create table(:notifications) do
      add :type, :string
      add :message, :string
      add :title, :string
      add :actions, {:array, :map}
      add :user_id, references(:users, on_delete: :nothing)
      add :read, :boolean, default: false

      timestamps()
    end

    create index(:notifications, [:user_id])
  end
end
