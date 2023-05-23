defmodule ProblemService.Schema.Problem do
  use Ecto.Schema
  import Ecto.Changeset

  schema "problems" do
    field :title, :string
    field :slug, :string
    field :blurb, :string
    field :overview, :string
    field :status, :string, default: "DRAFT"
    field :img, :string
    belongs_to :user, ProblemService.Schema.User
    belongs_to :sector, ProblemService.Schema.Sector
    has_many :problem_followers, ProblemService.Schema.ProblemFollower
    has_many :followers, through: [:problem_followers, :user]
    has_many :solutions, ProblemService.Schema.Solution

    timestamps()
  end

  @doc false

  def changeset(user, attrs) do
    # attrs = Map.put(attrs ,"avatar_id", Ecto.UUID.generate())

    required = [:title,:overview,:slug, :sector_id, :user_id]
    additional = [
      :img, :blurb
    ]

    user
    |> cast(attrs, required ++ additional)
    |> validate_required(required)
  end

  def to_string(problem) do
    "<title>#{problem.title}<title>
    <overview>#{problem.overview}</overview>
    "
  end
end
