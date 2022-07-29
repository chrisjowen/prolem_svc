defmodule EventService.Repo.Migrations.AddLocationToEvent do
  use Ecto.Migration

  def change do
    alter table(:events) do
      add :location,  :geometry
    end
  end
end
