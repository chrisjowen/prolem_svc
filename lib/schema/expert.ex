defmodule ProblemService.Schema.Expert do
  use Ecto.Schema
  import Ecto.Changeset

  schema "experts" do
    field :active, :boolean, default: true
    field :bio, :string
    field :email, :string
    field :slug, :string
    field :expertise, {:array, :string}
    field :img, :string
    field :institution, :string
    field :location, :string
    field :name, :string
    field :title, :string
    field :user_id, :id
    timestamps()
  end

  @doc false
  def changeset(expert, attrs) do
    required = [
      :name,
      :slug,
      :email
    ]
    additional = [
      :user_id,
      :institution,
      :img,
      :bio,
      :expertise,
      :location,
      :title,
      :active
    ]

    expert
    |> cast(attrs, required ++ additional)
    |> validate_required(required)
  end
end
