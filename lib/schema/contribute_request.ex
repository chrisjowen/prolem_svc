defmodule ProblemService.Schema.ContributeRequest do
  use Ecto.Schema
  import Ecto.Changeset

  schema "contribute_requests" do
    field :capacity, :string
    field :message, :string
    belongs_to :problem, ProblemService.Schema.Problem
    belongs_to :user, ProblemService.Schema.User

    timestamps()
  end

  @doc false
  def changeset(contribute_request, attrs) do
    contribute_request
    |> cast(attrs, [:capacity, :message, :problem_id, :user_id])
    |> validate_required([:capacity, :message, :problem_id, :user_id])
  end
end
