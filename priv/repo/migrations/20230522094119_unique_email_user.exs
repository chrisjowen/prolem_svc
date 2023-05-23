defmodule ProblemService.Repo.Migrations.UniqueEmailUser do
  use Ecto.Migration

  def change do
    create unique_index(:users, [:email], name: :unique_email_user)
  end
end
