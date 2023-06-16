defmodule ProblemService.Schema.Page do
  use Ecto.Schema
  import Ecto.Changeset

  schema "pages" do
    field :body, :string
    field :status, :string, default: "draft"
    field :tags, {:array, :string}
    field :title, :string
    field :version, :integer, default: 1

    belongs_to :problem, ProblemService.Schema.Problem
    belongs_to :user, ProblemService.Schema.User
    belongs_to :parent, ProblemService.Schema.Page

    timestamps()
  end

  @doc false
  def changeset(page, attrs) do
    page
    |> cast(attrs, [:title, :body, :tags, :version, :status, :parent_id, :user_id, :problem_id])
    |> validate_required([:title, :body, :version, :status, :user_id, :problem_id])
  end
end
