defmodule Totem.Repo.Migrations.CreateGrouoInvites do
  use Ecto.Migration

  def change do
    create table(:group_invites) do
      add :status, :string
      add :user_id, references(:users, on_delete: :nothing)
      add :to_id, references(:users, on_delete: :nothing)
      add :group_id, references(:groups, on_delete: :nothing)

      timestamps()
    end

    create index(:group_invites, [:user_id])
    create index(:group_invites, [:to_id])
    create index(:group_invites, [:group_id])
  end
end
