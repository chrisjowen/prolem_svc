defmodule ProblemService.Repo.Migrations.AddTypeToUser do
  use Ecto.Migration
  alias ProblemService.Schema.User
  alias ProblemService.Repo

  def up do
    alter table(:users) do
      add :type, :string, default: "human", null: false
    end

    flush()

    Repo.transaction(fn ->
      User.changeset(%User{}, %{
        type: "system",
        name: "CrowdSolve",
        last_name: "assistant",
        email: "help@crowdsolve.ai",
        username: "crowdsolve",
        password: "Letmein123!!!"
      })
      |> Repo.insert!()
    end)
  end

  def down do
    alter table(:users) do
      remove :type
      remove :profile_pic
    end
  end
end
