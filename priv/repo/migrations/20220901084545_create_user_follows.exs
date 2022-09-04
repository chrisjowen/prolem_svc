defmodule Totem.Repo.Migrations.CreateUserFollows do
  use Ecto.Migration

  def change do
    create table(:user_follows) do
      add :relationship, :string
      add :user_id, references(:users, on_delete: :nothing)
      add :to_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create index(:user_follows, [:user_id])
    create index(:user_follows, [:to_id])
  end
end
