defmodule ProblemService.Repo.Migrations.RemoveNullNotifications do
  use Ecto.Migration

  def change do
    alter table(:notifications) do
      modify :title, :string, null: true
      modify :content, :string, null: true
    end
  end
end
