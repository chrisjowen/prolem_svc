defmodule ProblemService.Repo.Migrations.CreateProduct do
  use Ecto.Migration


  def change do
    create table(:products) do
      add :name, :string
      add :url, :string
      add :description, :string
      add :match_percent, :integer
      add :crunchbaseURL, :string
      add :productHuntUrl, :string
      add :screenshot, :string
      add :problem_id, references(:problems, on_delete: :nothing)
      # add :user_id, references(:users, on_delete: :nothing)
      timestamps()
    end

    create index(:products, [:problem_id])
    # create index(:products, [:user_id])
  end

end
