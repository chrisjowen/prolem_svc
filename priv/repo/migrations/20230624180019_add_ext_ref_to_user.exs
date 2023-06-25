defmodule ProblemService.Repo.Migrations.AddExtRefToUser do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :ext_id, :string
      add :ext_ref, :string
    end
  end
end
