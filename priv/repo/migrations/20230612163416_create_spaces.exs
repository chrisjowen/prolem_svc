defmodule ProblemService.Repo.Migrations.CreateSpaces do
  use Ecto.Migration

  def change do
    create table(:spaces) do
      add :description, :string
      add :slug, :string
      add :owner, references(:users, on_delete: :nothing)

      timestamps()
    end

    create index(:spaces, [:owner])
  end
end
