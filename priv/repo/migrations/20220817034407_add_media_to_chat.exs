defmodule Totem.Repo.Migrations.AddMediaToChat do
  use Ecto.Migration

  def change do
    alter table(:group_chats) do
      add :media_id, :uuid
    end

    create index(:group_chats, [:media_id])
  end
end
