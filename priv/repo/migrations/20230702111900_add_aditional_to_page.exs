defmodule ProblemService.Repo.Migrations.AddAditionalToPage do
  use Ecto.Migration

  def change do
    alter table(:pages) do
      add :slug, :string
      add :scope, :string, default: "problem"
      add :priority, :integer, default: 1
    end

  end
end
