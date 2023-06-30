defmodule ProblemService.Repo.Migrations.UpdateIdea do
  use Ecto.Migration

  def change do
    alter table(:ideas) do
      remove :problem_statement
      remove :blurb
      remove :slug
      remove :sector_id
      remove :status
      add :tags, {:array, :string}
      add :features, {:array, :string}
      add :complexity, :integer
      add :skills, {:array, :string}
    end
  end

end
