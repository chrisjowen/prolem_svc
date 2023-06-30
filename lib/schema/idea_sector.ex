defmodule ProblemService.Schema.IdeaSector do
  use Ecto.Schema
  import Ecto.Changeset

  schema "idea_sectors" do
    belongs_to :sector, ProblemService.Schema.Sector
    belongs_to :idea, ProblemService.Schema.Idea
  end

  @doc false
  def changeset(idea_sector, attrs) do
    idea_sector
    |> cast(attrs, [:idea_id, :sector_id])
    |> validate_required([:idea_id, :sector_id])
  end
end
