defmodule Totem.Repo.Migrations.CreateGroupMembers do
  use Ecto.Migration

  def change do
    create table(:group_members) do
      add :is_host, :boolean, default: false, null: false
      add :status, :string
      add :user_id, references(:users, on_delete: :nothing)
      add :group_id, references(:groups, on_delete: :nothing)
      timestamps()
    end

    create index(:group_members, [:user_id])
    create index(:group_members, [:group_id])
  end
end
