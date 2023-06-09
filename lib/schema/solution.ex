defmodule ProblemService.Schema.Solution do
  use Ecto.Schema
  import Ecto.Changeset

  schema "solutions" do
    field :description, :string
    field :keyFeatures, {:array, :string}
    field :userStories, {:array, :string}
    field :estimatedCost, :string
    field :estimatedTeamSize, :integer
    field :estimatedTimescale, :string
    field :technologies, {:array, :string}
    field :expertise, {:array, :string}

    belongs_to :user, ProblemService.Schema.User
    belongs_to :problem, ProblemService.Schema.Problem

    has_many :solution_members, ProblemService.Schema.SolutionMember
    has_many :comments, ProblemService.Schema.Comment
    has_many :announcements, ProblemService.Schema.Announcement
    has_many :members, through: [:solution_members, :user]

    timestamps()
  end

  @doc false

  def changeset(schema, attrs) do
    # attrs = Map.put(attrs ,"avatar_id", Ecto.UUID.generate())

    required = [:description, :problem_id]
    additional = [
      :keyFeatures,
      :estimatedTeamSize,
      :estimatedCost,
      :estimatedTimescale, :technologies, :expertise, :userStories
    ]

    schema
    |> cast(attrs, required ++ additional)
    |> validate_required(required)
  end

end
