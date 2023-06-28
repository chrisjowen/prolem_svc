defmodule ProblemService.Repo.Migrations.AlterStakeholder do
  use Ecto.Migration

  def change do
    alter table(:stakeholders) do
      add :benefits, :string
      add :education, :string
      add :professions, {:array, :string}
      add :interests, {:array, :string}
      add :user_id, references(:users, on_delete: :nothing)
      remove :when
      remove :traits
    end

    create index(:stakeholders, [:user_id])
  end
end
