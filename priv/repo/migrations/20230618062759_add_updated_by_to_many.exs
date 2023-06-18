defmodule ProblemService.Repo.Migrations.AddUpdatedByToMany do
  use Ecto.Migration

  def change do
    [:problems, :discussions, :answers, :links, :pages] |> Enum.each(fn table ->
      alter table(table) do
        add :updated_by_id, references(:users, on_delete: :nothing)
      end

      create index(table, [:updated_by_id])
    end)
  end
end
