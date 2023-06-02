defmodule ProblemService.Schema.ProblemFollower do
  use Ecto.Schema
  import Ecto.Changeset

  schema "problem_followers" do
    belongs_to :user, ProblemService.Schema.User
    belongs_to :problem, ProblemService.Schema.Problem
  end

  @doc false

  def changeset(user, attrs) do
    required = [:user_id, :problem_id]
    additional = []

    user
    |> cast(attrs, required ++ additional)
    |> validate_required(required)
  end




end
