defmodule ProblemService.Repo.Migrations.AddFts do
  use Ecto.Migration


  def up do
    execute("CREATE EXTENSION pg_trgm IF NOT EXISTS pg_trgm")
    execute "CREATE INDEX problems_overview_trgm_index ON problems USING gin (overview gin_trgm_ops);"
  end

  def down do
    execute("DROP EXTENSION pg_trgm IF EXISTS pg_trgm")
    execute "DROP INDEX users_username_trgm_index;"
  end
end
