defmodule ProblemService.Repo.Migrations.AddReferencesAndTagsToDiscussions do
  use Ecto.Migration

  def change do
    alter table(:discussions) do
      add :tags, {:array, :string}
    end
  end
end
