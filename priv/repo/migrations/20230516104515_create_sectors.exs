defmodule ProblemService.Repo.Migrations.CreateSectors do
  use Ecto.Migration

  def change do
    create table(:sectors) do
      add :name, :string
      add :description, :text
      add :image, :text
      timestamps()
    end
  end
end
