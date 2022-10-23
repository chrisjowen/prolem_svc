defmodule Totem.Repo.Migrations.IndexEventDates do
  use Ecto.Migration

  def change do

    create index(:event_dates, [:start])
    create index(:event_dates, [:end])
    create unique_index(:events, :url)
  end
end
