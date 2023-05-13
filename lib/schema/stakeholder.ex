defmodule ProblemService.Schema.Stakeholder do
  use Ecto.Schema
  import Ecto.Changeset

  schema "stakeholders" do
    field :type, :string
    field :description, :string
    field :problems, {:array, :string}
    field :age_from, :integer
    field :age_to, :integer
    field :regions, {:array, :string}
    field :when, :string
    field :gender, :string
    field :traits, {:array, :string}
    field :socioEcenomics, {:array, :string}
    field :races, {:array, :string}
    # belongs_to :user, ProblemService.Schema.User
    belongs_to :problem, ProblemService.Schema.Problem
    timestamps()
  end

  @doc false

  def changeset(schema, attrs) do
    # attrs = Map.put(attrs ,"avatar_id", Ecto.UUID.generate())

    required = [:type,:description, :problems, :problem_id]
    additional = [
      :age_from,
      :age_to,
      :regions,
      :when,
      :gender,
      :traits,
      :socioEcenomics,
      :races

    ]

    schema
    |> cast(attrs, required ++ additional)
    |> validate_required(required)
  end




end
