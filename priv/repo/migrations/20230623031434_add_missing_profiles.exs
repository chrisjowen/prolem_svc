defmodule ProblemService.Repo.Migrations.AddMissingProfiles do
  use Ecto.Migration
  alias ProblemService.Schema.{UserProfile, User}
  alias ProblemService.Repo


  def change do

    alter table(:users) do
      add :tagline, :string
    end

    flush()

    Repo.transaction(fn ->
      User
      |> Repo.all()
      |> Enum.each(fn d ->

        Repo.update!(User.changeset(d, %{tagline: "Maker of things"}))
        Repo.insert!(
          UserProfile.changeset(
            %UserProfile{},
            %{
              intro: "Please complete me" ,
              country: "Singapore",
              user_id: d.id
            }
          )
        )
      end)
    end)
  end
end
