defmodule ProblemService.Repo.Migrations.AddTagsToLinks do
  use Ecto.Migration

  def change do
    alter table(:links) do
      add :tags, {:array, :string}, default: []
    end
  end
end
