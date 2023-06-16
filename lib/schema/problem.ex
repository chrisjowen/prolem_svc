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
    belongs_to :space, ProblemService.Schema.Space
    belongs_to :user, ProblemService.Schema.User
    belongs_to :sector, ProblemService.Schema.Sector
    has_many :problem_followers, ProblemService.Schema.Follower
    has_many :followers, through: [:problem_followers, :user]
    has_many :solutions, ProblemService.Schema.Solution
    has_many :products, ProblemService.Schema.Product
    has_many :problem_users, ProblemService.Schema.ProblemUser
    has_many :users, through: [:problem_users, :user]

    timestamps()
  end

  @doc false

  def changeset(user, attrs) do
    required = [:title, :overview, :slug, :sector_id, :user_id]

    additional = [
      :img,
      :blurb,
      :space_id
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

  def authorize(mode, user, problem) when mode in [:update, :delete] do
    is_owner = problem.user_id == user.id
    is_admin =
      problem.problem_users
      |> Enum.any?(fn problem_user ->
        problem_user.role == "admin" && problem_user.member_id == user.id
      end)

    is_owner || is_admin
  end


end
