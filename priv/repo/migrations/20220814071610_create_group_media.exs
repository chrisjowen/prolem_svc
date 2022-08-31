defmodule Totem.Repo.Migrations.CreateGroupMedia do
  use Ecto.Migration

  def change do
    create table(:group_media, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :group_id, references(:groups, on_delete: :nothing)
      add :user_id, references(:users, on_delete: :nothing)

      add :type, :text
      add :media, :text

      timestamps()
    end

    create index(:group_media, [:group_id])
    create index(:group_media, [:user_id])
  end
end
