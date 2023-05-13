defmodule ProblemService.Repo.Migrations.CreateMonetizations do
  use Ecto.Migration

  def change do
    create table(:monetizations) do
      add :type, :text
      add :description, :text
      add :links, :map


      # belongs_to :user, ProblemService.Schema.User
      add :problem_id, references(:problems, on_delete: :nothing)
      add :solution_id, references(:solutions, on_delete: :nothing)
      timestamps()
    end
  end
end
