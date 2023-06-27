defmodule ProblemService.Schema.ComingSoon do
  use Ecto.Schema
  import Ecto.Changeset

  schema "coming_soons" do
    field :content, :string
    field :icon, :string
    field :scope, :string
    field :title, :string

    timestamps()
  end

  @doc false
  def changeset(coming_soon, attrs) do
    coming_soon
    |> cast(attrs, [:scope, :icon, :content, :title])
    |> validate_required([:scope, :icon, :content, :title])
  end
end
