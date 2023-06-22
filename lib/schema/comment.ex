defmodule ProblemService.Schema.Comment do
  use Ecto.Schema
  import Ecto.Changeset

  schema "comments" do
    field :comment, :string
    belongs_to :user, ProblemService.Schema.User
    belongs_to :solution, ProblemService.Schema.Solution
    belongs_to :problem, ProblemService.Schema.Problem
    belongs_to :discussion, ProblemService.Schema.Discussion
    belongs_to :answer, ProblemService.Schema.Answer
    timestamps()
  end

  @doc false
  def changeset(comment, attrs) do

    owner = [
      :solution_id,
      :problem_id,
      :discussion_id,
      :answer_id
    ]

    comment
    |> cast(attrs, [:comment, :user_id] ++ owner)
    |> validate_required([:comment, :user_id])
    |> Util.EctoUtil.validate_required_inclusion(owner)
  end


end
