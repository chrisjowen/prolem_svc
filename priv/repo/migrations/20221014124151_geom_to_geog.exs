defmodule Totem.Repo.Migrations.GeomToGeog do
  use Ecto.Migration

  def change do
    alter table(:events) do
      modify :location, :geography
    end
  end
end
