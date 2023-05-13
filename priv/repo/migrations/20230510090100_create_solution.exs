defmodule ProblemService.Repo.Migrations.CreateSolution do
  use Ecto.Migration

  def change do
    create table(:solutions) do
      add :description, :text
      add :keyFeatures, {:array, :text}
      add :userStories, {:array, :text}
      add :estimatedCost, :string
      add :estimatedTeamSize, :integer
      add :estimatedTimescale, :string
      add :technologies, {:array, :string}
      add :expertise, {:array, :string}


      # belongs_to :user, ProblemService.Schema.User
      add :problem_id, references(:problems, on_delete: :nothing)
      # add :user_id, references(:users, on_delete: :nothing)
      timestamps()
    end
  end
end
