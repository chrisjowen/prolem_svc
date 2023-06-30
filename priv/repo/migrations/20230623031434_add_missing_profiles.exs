defmodule ProblemService.Repo.Migrations.AddMissingProfiles do
  use Ecto.Migration
  alias ProblemService.Schema.{UserProfile, User}
  alias ProblemService.Repo


  def change do

    alter table(:users) do
      add :tagline, :string
    end


  end
end
