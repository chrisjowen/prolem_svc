defmodule ProblemService.Repo.Migrations.UpdateLink do
  use Ecto.Migration

  def change do
    alter table(:links) do
      add :type, :string, default: "other"
    end
  end
end
