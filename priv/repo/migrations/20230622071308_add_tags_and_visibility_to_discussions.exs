defmodule ProblemService.Repo.Migrations.AddTagsAndVisibilityToDiscussions do
  alias ProblemService.Schema.Discussion
  alias ProblemService.Repo
  use Ecto.Migration

  def change do
    alter table(:discussions) do
      add :public, :boolean, default: true, nil: false
    end

    flush()

    Repo.transaction(fn ->
      Discussion
      |> Repo.all()
      |> Enum.each(fn d -> Repo.update!(Discussion.changeset(d, %{public: true, tags: []})) end)
    end)
  end
end
