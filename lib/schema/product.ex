defmodule ProblemService.Schema.Product do
  use Ecto.Schema
  import Ecto.Changeset

  schema "products" do
    field :name, :string
    field :url, :string
    field :description, :string
    field :match_percent, :integer
    field :crunchbaseURL, :string
    field :productHuntUrl, :string
    field :screenshot, :string

    # belongs_to :user, ProblemService.Schema.User
    belongs_to :problem, ProblemService.Schema.Problem
    timestamps()
  end

  @doc false

  def changeset(schema, attrs) do
    # attrs = Map.put(attrs ,"avatar_id", Ecto.UUID.generate())

    required = [:name,:url,:description,  :problem_id]
    additional = [
      :match_percent, :crunchbaseURL, :productHuntUrl, :screenshot
    ]

    schema
    |> cast(attrs, required ++ additional)
    |> validate_required(required)
  end




end
