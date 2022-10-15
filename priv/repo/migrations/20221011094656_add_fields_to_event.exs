defmodule Totem.Repo.Migrations.AddFieldsToEvent do
  use Ecto.Migration

  def change do
    alter table(:events) do
      add :provider, :string
      add :ref, :uuid
      add :url, :string
      add :blurb, :string
      add :tags, {:array, :string}
    end
  end
end
