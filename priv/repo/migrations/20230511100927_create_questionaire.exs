defmodule ProblemService.Repo.Migrations.CreateQuestionaire do
  use Ecto.Migration

  def change do
    create table(:questionaires) do
      add :questions, {:array, :map}
      add :problem_id, references(:problems, on_delete: :nothing)
      add :stakeholder_id, references(:stakeholders, on_delete: :nothing)
      timestamps()
    end
  end
end
