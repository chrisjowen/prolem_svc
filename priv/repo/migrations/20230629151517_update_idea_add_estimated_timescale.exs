defmodule ProblemService.Repo.Migrations.UpdateIdeaAddEstimatedTimescale do
  use Ecto.Migration

  def change do
    alter table(:ideas) do
      add :estimated_timescale, :integer
    end
  end
end
