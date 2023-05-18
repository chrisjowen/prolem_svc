defmodule ProblemService.Schema.Sector do
  use Ecto.Schema
  import Ecto.Changeset

  schema "sectors" do
    field :name, :string
    field :description, :string
    field :image, :string
    has_many :problems, ProblemService.Schema.Problem

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
