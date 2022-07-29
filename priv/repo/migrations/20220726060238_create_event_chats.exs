defmodule EventService.Repo.Migrations.CreateEventChats do
  use Ecto.Migration

  def change do
    create table(:event_chats) do
      add :msg, :text
      add :event_id, references(:events, on_delete: :nothing)
      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create index(:event_chats, [:event_id])
    create index(:event_chats, [:user_id])
  end
end
