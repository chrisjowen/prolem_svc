defmodule ProblemService.Repo.Migrations.AddFts do
  use Ecto.Migration


  def up do
    execute("CREATE EXTENSION IF NOT EXISTS pg_trgm")
  end

  def down do
    execute("DROP EXTENSION IF EXISTS pg_trgm")
  end
end
