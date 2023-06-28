defmodule ProblemService.Repo.Migrations.AddImageToStakeholder do
  use Ecto.Migration

  def change do
    alter table(:stakeholders) do
      add :img, :string
    end
  end
end
