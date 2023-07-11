defmodule ProblemService.Repo.Migrations.AddGenerationToProblem do
  use Ecto.Migration

  def change do
    alter table(:problems) do
      add :generated, :boolean, default: true, nil: false
    end
  end
end
