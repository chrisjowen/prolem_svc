defmodule Totem.Repo.Migrations.CreateEventDates do
  use Ecto.Migration

  def change do
    create table(:event_dates) do
      add :start, :utc_datetime
      add :end, :utc_datetime
      add :event_id, references(:events, on_delete: :nothing)
    end

    create index(:event_dates, [:event_id])
  end
end
