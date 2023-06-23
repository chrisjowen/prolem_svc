defmodule ProblemService.Repo.Migrations.CreateUserProfiles do
  use Ecto.Migration

  def change do
    create table(:user_profiles) do
      add :intro, :text
      add :linkedin, :string
      add :country, :string
      add :accomplishments, :text
      add :hightst_education, :string
      add :twitter, :string
      add :technical, :boolean, default: false, null: false
      add :skills, {:array, :string}
      add :interests, {:array, :string}
      add :languages, {:array, :map}
      add :start_working, :naive_datetime
      add :anything_else, :string
      add :open_to_invites, :boolean, default: false, null: false
      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    alter table(:users) do
      remove :dob
      remove :nationality
      remove :gender
    end

    create index(:user_profiles, [:user_id])
  end
end
