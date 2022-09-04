defmodule Totem.Repo.Migrations.CreateGroups do
  use Ecto.Migration

  def change do
    create table(:groups) do
      add :title, :string
      add :start, :naive_datetime
      add :description, :string
      add :place_id, :string
      add :place_name, :string
      add :place_address, :string
      add :banner, :string

      timestamps()
    end
  end
end
