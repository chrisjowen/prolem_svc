defmodule ProblemService.Repo.Migrations.CreateUser do
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
  end
end
