defmodule ProblemService.Schema.Link do
  use Ecto.Schema
  import Ecto.Changeset

  schema "links" do
    field :description, :string
    field :icon, :string
    field :screenshot, :string
    field :text, :string
    field :url, :string
    field :type, :string, default: "other"



    belongs_to :user, ProblemService.Schema.User
    belongs_to :solution, ProblemService.Schema.Solution
    belongs_to :problem, ProblemService.Schema.Problem

    timestamps()
  end

  @doc false
  def changeset(link, attrs) do
    link
    |> cast(attrs, [:url, :text, :icon, :screenshot, :description, :user_id, :solution_id, :problem_id, :type])
    |> validate_required([:url, :text])
    |> Util.EctoUtil.validate_required_inclusion([:solution_id, :problem_id])
  end
end
