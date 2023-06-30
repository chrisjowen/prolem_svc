defmodule ProblemService.Schema.Idea do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query

  schema "ideas" do
    field :title, :string
    field :description, :string
    field :img, :string
    field :tags, {:array, :string}
    field :features, {:array, :string}
    field :complexity, :integer
    field :estimated_timescale, :integer
    field :skills, {:array, :string}
    has_many :idea_sectors, ProblemService.Schema.IdeaSector
    has_many :sectors, through: [:idea_sectors, :sector]
    has_many :comments, ProblemService.Schema.Comment

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    required = [:title, :description]

    additional = [
      :img,
      :estimated_timescale,
      :tags,
      :features,
      :complexity,
      :skills
    ]

    user
    |> cast(attrs, required ++ additional)
    |> validate_required(required)
  end

  def with_sectors(query, sector_ids) do
    case sector_ids do
      [""] ->
        query

      _ ->
        from i in query,
          join: is in assoc(i, :idea_sectors),
          where: is.sector_id in ^sector_ids
    end
  end
end
