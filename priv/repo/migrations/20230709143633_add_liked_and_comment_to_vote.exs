defmodule ProblemService.Repo.Migrations.AddLikedAndCommentToVote do
  use Ecto.Migration

  def change do
    alter table(:votes) do
      add :liked, :boolean, default: true, null: false
      add :comment, :string
    end
  end
end
