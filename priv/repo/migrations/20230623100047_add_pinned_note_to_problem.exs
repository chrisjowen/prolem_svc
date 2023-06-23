defmodule ProblemService.Repo.Migrations.AddPinnedNoteToProblem do
  use Ecto.Migration

  def change do
    alter table(:problems) do
      add :pinned_note, :string
    end
  end
end
