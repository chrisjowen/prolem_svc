defmodule ProblemService.Schema.Idea do
  use Ecto.Schema
  import Ecto.Changeset

  schema "ideas" do
    field :title, :string
    field :slug, :string
    field :blurb, :string
    field :description, :string
    field :status, :string, default: "DRAFT"
    field :img, :string
    field :problem_statement, :string
    belongs_to :sector, ProblemService.Schema.Sector
    timestamps()
  end

  @doc false

  def changeset(user, attrs) do
    required = [:title,:description, :sector_id]
    additional = [
      :img, :blurb, :status, :problem_statement,
    ]

    user
    |> cast(attrs, required ++ additional)
    |> validate_required(required)
  end

end
