defmodule ProblemService.Repo.Migrations.AddPasswordAndSaltToUser do
  alias Guardian.UUID
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :password, :string
      add :salt, :string, default: UUID.generate()
    end
  end
end
