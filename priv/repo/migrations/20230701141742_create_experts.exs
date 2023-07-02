defmodule ProblemService.Repo.Migrations.CreateExperts do
  use Ecto.Migration

  def change do
    create table(:experts) do
      add :name, :string, null: false
      add :email, :string, null: false
      add :slug, :string, null: false
      add :bio, :text
      add :institution, :string
      add :img, :string
      add :expertise, {:array, :string}
      add :location, :string
      add :title, :string
      add :active, :boolean, default: false, null: false
      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create index(:experts, [:user_id])
  end
end
