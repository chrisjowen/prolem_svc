defmodule Totem.Repo.Migrations.CreateGroupTypes do
  use Ecto.Migration

  def change do
    create table(:group_types) do
      add :name, :string

      timestamps()
    end
  end
end
