defmodule Totem.Repo.Migrations.CreateGroupChats do
  use Ecto.Migration

  def change do
    create table(:group_chats) do
      add :msg, :text
      add :group_id, references(:groups, on_delete: :nothing)
      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create index(:group_chats, [:group_id])
    create index(:group_chats, [:user_id])
  end
end
