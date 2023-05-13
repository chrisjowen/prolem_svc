defmodule ProblemService.Schema.Monetization do
  use Ecto.Schema
  import Ecto.Changeset

  schema "monetizations" do
    field :description, :string
    field :type, :string

    embeds_many :links, Link do
      field :url, :string
      field :description, :string
    end

    # belongs_to :user, ProblemService.Schema.User
    belongs_to :solution, ProblemService.Schema.Solution
    belongs_to :problem, ProblemService.Schema.Problem
    timestamps()
  end

  @doc false

  def changeset(schema, attrs) do
    # attrs = Map.put(attrs ,"avatar_id", Ecto.UUID.generate())

    required = [:description, :type, :problem_id, :solution_id]
    additional = [
      :links
    ]

    schema
    |> cast(attrs, required ++ additional)
    |> validate_required(required)
  end




end
