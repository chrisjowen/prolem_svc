defmodule Totem.Repo.Migrations.AddUniqeToEmailAndNicknake do
  use Ecto.Migration

  def change do
    create unique_index(:credentials, :username)
    create unique_index(:users, :email)
    create unique_index(:users, :nickname)
  end
end
