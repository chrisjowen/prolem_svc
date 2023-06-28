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
    field :gender, :string

    # remove
    # field :when, :string
    # field :traits, {:array, :string}

    # Add
    field :img, :string
    field :benefits, :string
    field :professions, {:array, :string}
    field :education, :string
    field :interests, {:array, :string}

    field :races, {:array, :string}
    field :socioEcenomics, {:array, :string}


    # belongs_to :user, ProblemService.Schema.User
    belongs_to :problem, ProblemService.Schema.Problem
    belongs_to :user, ProblemService.Schema.User
    timestamps()
  end

  @doc false

  def changeset(schema, attrs) do
    required = [:type,:description, :problems, :problem_id, :user_id]
    additional = [
      :age_from,
      :age_to,
      :regions,
      :gender,
      :socioEcenomics,
      :races,
      :benefits,
      :professions,
      :education,
      :interests,
      :img
    ]

    schema
    |> cast(attrs, required ++ additional)
    |> validate_required(required)
  end




end
