defmodule ProblemService.Repo.Migrations.AddUsernameToUser do
  use Ecto.Migration
  alias ProblemService.Schema.User
  alias ProblemService.Repo

  def up do
    alter table(:users) do
      remove(:nickname)
      add :username, :string
    end


  end

  def down do
    alter table(:users) do
      remove :username
    end
  end
end
