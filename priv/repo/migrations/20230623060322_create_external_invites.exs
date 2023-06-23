defmodule ProblemService.Repo.Migrations.CreateExternalInvites do
  use Ecto.Migration

  def change do
    create table(:problem_invites) do
      add :email, :string
      add :type, :string
      add :identifier, :string
      add :problem_id, references(:problems, on_delete: :nothing)
      add :used, :boolean, default: false, nil: false
      add :user_id, references(:users, on_delete: :nothing)
    end

    create index(:problem_invites, [:problem_id])
    create index(:problem_invites, [:user_id])
  end
end
