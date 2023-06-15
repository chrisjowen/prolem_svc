defmodule ProblemService.Schema.Obstacle do
  use Ecto.Schema
  import Ecto.Changeset


  defmodule StateHistory do
    use Ecto.Schema

    embedded_schema do
      field :state, :string
      field :notes, :string
    end

    def changeset(model, attrs) do

      required = [:state, :notes]
      additional = []

      model
      |> cast(attrs, required ++ additional)
      |> validate_required(required)
    end
  end



  schema "obstacles" do
    field :description, :string
    field :hint, :string
    field :questions, {:array, :string}, default: []
    field :tags, {:array, :string}
    field :state, :string, default: "new"
    belongs_to :problem, ProblemService.Schema.Problem
    embeds_many :state_history, StateHistory
    timestamps()
  end

  @doc false
  def changeset(obstacle, attrs) do
    obstacle
    |> cast(attrs, [:description, :tags, :questions, :hint, :problem_id, :state])
    |> cast_embed(:state_history, with: &StateHistory.changeset/2)
    |> validate_required([:description, :tags, :questions, :problem_id])
  end
end
