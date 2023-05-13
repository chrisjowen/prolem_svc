defmodule ProblemService.Schema.Questionaire do
  use Ecto.Schema
  import Ecto.Changeset

  defmodule Question do
    use Ecto.Schema

    embedded_schema do
      field :question, :string
      field :type, :string
      field :options, {:array, :string}
    end

    def changeset(model, attrs) do
      # attrs = Map.put(attrs ,"avatar_id", Ecto.UUID.generate())

      required = [:question, :type]
      additional = [:options]

      model
      |> cast(attrs, required ++ additional)
      |> validate_required(required)
    end
  end

  schema "questionaires" do
    embeds_many :questions, Question

    belongs_to :problem, ProblemService.Schema.Problem
    belongs_to :stakeholder, ProblemService.Schema.Stakeholder

    timestamps()
  end

  @doc false

  def changeset(user, attrs) do
    # attrs = Map.put(attrs ,"avatar_id", Ecto.UUID.generate())

    required = [:stakeholder_id, :problem_id]
    additional = []

    user
    |> cast(attrs, required ++ additional)
    |> cast_embed(:questions, with: &Question.changeset/2)
    |> validate_required(required)
  end

  def to_string(problem) do
    "<title>#{problem.title}<title>
    <overview>#{problem.overview}</overview>
    "
  end
end
