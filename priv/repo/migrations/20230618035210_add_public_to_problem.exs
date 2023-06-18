defmodule ProblemService.Repo.Migrations.AddPublicToProblem do
  use Ecto.Migration

  def change do
    alter table(:problems) do
      add :public, :boolean, default: true, null: false
    end
    alter table(:problem_users) do
      add :status, :string, [default: "accepted", null: false]
    end
  end
end
