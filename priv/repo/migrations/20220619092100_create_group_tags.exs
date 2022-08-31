defmodule Totem.Repo.Migrations.CreateGroupTags do
  use Ecto.Migration

  def change do
    create table(:group_tags) do
      add :group_id, references(:groups, on_delete: :nothing)
      add :tag_id, references(:tags, on_delete: :nothing)
    end

    create index(:group_tags, [:group_id])
    create index(:group_tags, [:tag_id])
  end
end
