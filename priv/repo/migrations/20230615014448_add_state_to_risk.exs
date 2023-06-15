defmodule ProblemService.Repo.Migrations.AddStateToRisk do
  use Ecto.Migration

  def change do
    alter table(:obstacles) do
      add :state, :string, default: "new", null: false
      add :state_history, {:array, :map}
    end
  end
end
