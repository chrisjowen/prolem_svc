defmodule Totem.Repo.Migrations.CreateUserAndCreds do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :name, :string
      add :last_name, :string
      add :gender, :string
      add :email, :string
      add :profile_pic, :string
      timestamps()
    end

    create table(:credentials) do
      add :username, :string
      add :password, :string
      add :salt, :string
      add :token, :string
      add :ext_ref, :string
      add :provider, :string
      add :user_id, references(:users, on_delete: :nothing)
      timestamps()
    end


    create index(:credentials, [:user_id])
  end
end
