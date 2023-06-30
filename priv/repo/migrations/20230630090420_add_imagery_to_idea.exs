defmodule ProblemService.Repo.Migrations.AddImageryToIdea do
  use Ecto.Migration

  def change do
    alter table(:ideas) do
      add :imagery, :string
    end
  end
end
