defmodule Totem.Repo.Migrations.AddLocationToGroup do
  use Ecto.Migration

  def change do
    alter table(:groups) do
      add :location,  :geography
    end
  end
end
