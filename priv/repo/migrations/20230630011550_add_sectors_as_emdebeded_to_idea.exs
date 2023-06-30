defmodule ProblemService.Repo.Migrations.AddSectorsAsEmdebededToIdea do
  use Ecto.Migration

  def change do
    alter table(:ideas) do
      add :sectors, {:array, :map}
    end
  end
end
