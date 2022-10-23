defmodule Totem.Repo.Migrations.CreateEvents do
  use Ecto.Migration

  def change do
    create table(:events) do

      add :title, :string
      add :description, :text
      add :banner, :text
      add :location, :geometry
      add :start, :utc_datetime
      add :end, :utc_datetime
      add :place_id, :string
      add :user, references(:users, on_delete: :nothing)

      timestamps()
    end

    create index(:events, [:user])
  end
end
