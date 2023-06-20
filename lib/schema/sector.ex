defmodule ProblemService.Schema.Sector do
  use Ecto.Schema
  import Ecto.Changeset

  schema "sectors" do
    field :name, :string
    field :description, :string
    field :image, :string
    has_many :problem_sectors, ProblemService.Schema.ProblemSector
    has_many :problems, through: [:problem_sectors, :problem]


    timestamps()
  end

  @doc false
  def changeset(schema, attrs) do
    required = [:name, :description]
    additional = [
      :image
    ]

    schema
    |> cast(attrs, required ++ additional)
    |> validate_required(required)
  end




end
