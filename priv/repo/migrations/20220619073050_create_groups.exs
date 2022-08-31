defmodule Totem.Repo.Migrations.CreateGroups do
  use Ecto.Migration

  def change do
    create table(:groups) do
      add :title, :string
      add :start, :naive_datetime
      add :description, :string
      add :banner, :string

      timestamps()
    end
  end
end
