defmodule Totem.Repo.Migrations.AddFieldsToEvent do
  use Ecto.Migration

  def change do
    alter table(:events) do
      add :provider, :string
      add :ref, :uuid
      add :url, :string
    end
  end
end
