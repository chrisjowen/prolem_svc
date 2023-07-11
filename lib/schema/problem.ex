defmodule ProblemService.Schema.Problem do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query

  schema "problems" do
    field :title, :string
    field :slug, :string
    field :blurb, :string
    field :overview, :string
    field :status, :string, default: "DRAFT"
    field :img, :string
    field :banner_image, :string
    field :pinned_note, :string
    field :public, :boolean, default: true
    field :generated, :boolean, default: false

    belongs_to :space, ProblemService.Schema.Space
    belongs_to :user, ProblemService.Schema.User
    belongs_to :updated_by, ProblemService.Schema.User
    belongs_to :sector, ProblemService.Schema.Sector
    has_many :problem_followers, ProblemService.Schema.Follower
    has_many :followers, through: [:problem_followers, :user]
    has_many :solutions, ProblemService.Schema.Solution
    has_many :products, ProblemService.Schema.Product
    has_many :problem_users, ProblemService.Schema.ProblemUser
    has_many :users, through: [:problem_users, :member]
    has_many :problem_sectors, ProblemService.Schema.ProblemSector
    has_many :stakeholders, ProblemService.Schema.Stakeholder
    has_many :sectors, through: [:problem_sectors, :sector]
    has_many :votes,  ProblemService.Schema.Vote
    has_many :comments,  ProblemService.Schema.Comment
    has_many :contribution_requests,  ProblemService.Schema.ContributeRequest

    timestamps()
  end

  @doc false

  def changeset(user, attrs) do
    required = [:title, :blurb, :user_id]

    additional = [
      :overview,
      :slug,
      :sector_id,
      :img,
      :space_id,
      :updated_by_id,
      :banner_image,
      :pinned_note,
      :status,
      :generated
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

  def with_sectors(query, sector_ids \\ []) do
    case sector_ids do
      [""] -> query
      [] -> query
      _ ->
        from p in query,
          join: ps in assoc(p, :problem_sectors),
          where: ps.sector_id in ^sector_ids
    end
  end


end
