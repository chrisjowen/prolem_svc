defmodule EventService.Repo.Migrations.CreateEventMedia do
  use Ecto.Migration

  def change do
    create table(:event_media, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :event_id, references(:events, on_delete: :nothing)
      add :user_id, references(:users, on_delete: :nothing)

      add :type, :text
      add :media, :text

      timestamps()
    end

    create index(:event_media, [:event_id])
    create index(:event_media, [:user_id])
  end
end
