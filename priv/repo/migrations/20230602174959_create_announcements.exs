defmodule ProblemService.Repo.Migrations.CreateAnnouncements do
  use Ecto.Migration

  def change do
    create table(:announcements) do
      add :type, :string
      add :message, :string
      add :title, :string
      add :links, :map
      add :user_id, references(:users, on_delete: :nothing)
      add :solution_id, references(:solutions, on_delete: :nothing)

      timestamps()
    end

    create index(:announcements, [:user_id])
    create index(:announcements, [:solution_id])
  end
end
