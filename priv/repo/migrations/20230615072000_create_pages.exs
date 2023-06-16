defmodule ProblemService.Repo.Migrations.CreatePages do
  use Ecto.Migration

  def change do
    create table(:pages) do
      add :title, :string
      add :body, :text
      add :tags, {:array, :string}
      add :version, :integer, default: 1, null: false
      add :status, :string, default: "draft", null: false
      add :parent_id, references(:pages, on_delete: :nothing)
      add :problem_id, references(:problems, on_delete: :nothing)
      add :user_id, references(:users, on_delete: :nothing)
      timestamps()
    end

    create index(:pages, [:problem_id])
    create index(:pages, [:parent_id])
    create index(:pages, [:user_id])
  end
end
