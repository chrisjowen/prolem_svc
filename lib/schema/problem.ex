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
    timestamps()
  end

  @doc false

  def changeset(user, attrs) do
    # attrs = Map.put(attrs ,"avatar_id", Ecto.UUID.generate())

    required = [:title,:overview,:slug]
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
