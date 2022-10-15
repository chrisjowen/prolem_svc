defmodule Totem.Repo.Migrations.AddTypeToEvent do
  use Ecto.Migration

  def change do
    alter table(:events) do
       add :type_id, references(:event_types, on_delete: :nothing)
    end

    create index(:events, [:type_id])
  end
end
