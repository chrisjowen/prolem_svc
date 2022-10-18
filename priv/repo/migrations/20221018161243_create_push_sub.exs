defmodule Totem.Repo.Migrations.CreatePushSub do
  use Ecto.Migration

  def change do
    create table(:push_sub) do
      add :endpoint, :string
      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create index(:push_sub, [:user_id])
  end
end
