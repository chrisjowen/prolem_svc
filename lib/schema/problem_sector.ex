defmodule ProblemService.Schema.ProblemSector do
  use Ecto.Schema
  import Ecto.Changeset

  schema "problem_sectors" do

    belongs_to :problem, ProblemService.Schema.Problem
    belongs_to :sector, ProblemService.Schema.Sector
  end

  @doc false
  def changeset(problem_sector, attrs) do
    problem_sector
    |> cast(attrs, [:problem_id, :sector_id])
    |> validate_required([:problem_id, :sector_id])
  end
end
