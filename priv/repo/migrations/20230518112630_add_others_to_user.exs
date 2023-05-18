defmodule ProblemService.Repo.Migrations.AddOthersToUser do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :nickname, :string
      add :nationality, :string
      add :dob, :string
    end
  end
end
