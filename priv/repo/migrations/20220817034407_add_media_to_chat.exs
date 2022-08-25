defmodule EventService.Repo.Migrations.AddMediaToChat do
  use Ecto.Migration

  def change do
    alter table(:event_chats) do
      add :media_id, :uuid
    end

    create index(:event_chats, [:media_id])
  end
end
