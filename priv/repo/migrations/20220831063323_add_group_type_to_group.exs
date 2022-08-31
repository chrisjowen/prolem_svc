defmodule Totem.Repo.Migrations.AddGroupTypeToGroup do
  use Ecto.Migration

  def change do
    alter table(:groups) do
      add :type_id, references(:group_types, on_delete: :nothing)
    end

    create index(:groups, [:type_id])
  end
end
