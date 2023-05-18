defmodule ProblemService.Repo.Migrations.CreateIdea do
  use Ecto.Migration

  def change do
    create table(:ideas) do
      add :title, :string
      add :slug, :string
      add :blurb, :text
      add :status, :string, default: "DRAFT"
      add :description, :text
      add :problem_statement, :text
      add :img, :text
      add :sector_id, references(:sectors, on_delete: :nothing)
      timestamps()
    end
  end
end
