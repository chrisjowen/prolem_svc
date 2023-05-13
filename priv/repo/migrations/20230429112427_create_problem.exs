defmodule ProblemService.Repo.Migrations.CreateProblem do
  use Ecto.Migration

  def change do
    create table(:problems) do
      add :title, :string
      add :slug, :string
      add :blurb, :text
      add :status, :string
      add :img, :text
      add :overview, :text
      timestamps()
    end
  end

end
