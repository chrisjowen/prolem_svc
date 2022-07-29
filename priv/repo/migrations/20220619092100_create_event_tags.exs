defmodule EventService.Repo.Migrations.CreateEventTags do
  use Ecto.Migration

  def change do
    create table(:event_tags) do
      add :event_id, references(:events, on_delete: :nothing)
      add :tag_id, references(:tags, on_delete: :nothing)
    end

    create index(:event_tags, [:event_id])
    create index(:event_tags, [:tag_id])
  end
end
