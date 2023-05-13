defmodule ProblemService.Repo.Migrations.CreateStakeholder do
  use Ecto.Migration

  def change do
    create table(:stakeholders) do
      add :type, :string
      add :description, :text
      add :problems, {:array, :text}
      add :age_from, :integer
      add :age_to, :integer
      add :regions, {:array, :string}
      add :when, :string
      add :gender, :string
      add :traits, {:array, :string}
      add :socioEcenomics, {:array, :string}
      add :races, {:array, :string}
      # belongs_to :user, ProblemService.Schema.User
      add :problem_id, references(:problems, on_delete: :nothing)
      # add :user_id, references(:users, on_delete: :nothing)
      timestamps()
    end

    create index(:stakeholders, [:problem_id])
  end
end
