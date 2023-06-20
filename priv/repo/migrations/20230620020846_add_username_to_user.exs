defmodule ProblemService.Repo.Migrations.AddUsernameToUser do
  use Ecto.Migration
  alias ProblemService.Schema.User
  alias ProblemService.Repo

  def up do
    alter table(:users) do
      remove(:nickname)
      add :username, :string
    end

    flush()

    ProblemService.Repo.transaction(fn ->
      User
      |> Repo.all()
      |> Enum.each(fn record ->
        User.changeset(record, %{
          username: "#{String.downcase(record.name)}_#{String.downcase(record.last_name)}"
        })
        |> Repo.update!()
      end)
    end)
  end

  def down do
    alter table(:users) do
      remove :username
    end
  end
end
