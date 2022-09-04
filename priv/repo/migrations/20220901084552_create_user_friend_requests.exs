defmodule Totem.Repo.Migrations.CreateUserFriendRequests do
  use Ecto.Migration

  def change do
    create table(:user_friend_requests) do
      add :status, :string
      add :user_id, references(:users, on_delete: :nothing)
      add :to_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create index(:user_friend_requests, [:user_id])
    create index(:user_friend_requests, [:to_id])
  end
end
