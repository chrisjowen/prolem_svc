defmodule ProblemService.Schema.Page do
  use Ecto.Schema
  import Ecto.Changeset

  schema "pages" do
    field :body, :string
    field :status, :string, default: "draft"
    field :tags, {:array, :string}
    field :title, :string
    field :version, :integer, default: 1

    field :slug, :string
    field :scope, :string, default: "problem"
    field :priority, :integer, default: 1


    belongs_to :problem, ProblemService.Schema.Problem
    belongs_to :user, ProblemService.Schema.User
    belongs_to :updated_by, ProblemService.Schema.User
    belongs_to :parent, ProblemService.Schema.Page

    timestamps()
  end

  @doc false
  def changeset(page, attrs) do
    required = [
      :title,
      :body,
      :version,
      :status,
      :user_id,
      :scope
    ]
    additional = [
      :tags,
      :parent_id,
      :updated_by_id,
      :problem_id,
      :slug,
      :priority
    ]

    page
    |> cast(attrs, required ++ additional)
    |> validate_required(required)
  end
end
