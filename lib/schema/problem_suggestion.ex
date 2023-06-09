defmodule ProblemService.Schema.ProblemSuggestion do
  use Ecto.Schema
  import Ecto.Changeset

  schema "problem_suggestions" do
    field :blurb, :string
    field :status, :string, default: "draft"
    field :title, :string
    field :used, :boolean, default: false
    belongs_to :sector, ProblemService.Schema.Sector

    timestamps()
  end

  @doc false
  def changeset(problem_suggestion, attrs) do
    problem_suggestion
    |> cast(attrs, [:title, :blurb, :status, :used, :sector_id])
    |> validate_required([:title, :blurb, :status, :used, :sector_id])
  end
end
