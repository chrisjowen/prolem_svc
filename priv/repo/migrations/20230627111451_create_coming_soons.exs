defmodule ProblemService.Repo.Migrations.CreateComingSoons do
  use Ecto.Migration

  def change do
    create table(:coming_soons) do
      add :scope, :string
      add :icon, :string
      add :content, :text
      add :title, :string

      timestamps()
    end
  end
end
