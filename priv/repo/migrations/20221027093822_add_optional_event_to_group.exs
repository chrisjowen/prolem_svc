defmodule Totem.Repo.Migrations.AddOptionalEventToGroup do
  use Ecto.Migration

  def change do
      alter table(:groups) do
         add :event_id, references(:events, on_delete: :nothing)
      end

      create index(:groups, [:event_id])
  end
end
