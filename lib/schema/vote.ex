defmodule ProblemService.Schema.Vote do
  use Ecto.Schema
  import Ecto.Changeset

  schema "votes" do


    belongs_to :user, ProblemService.Schema.User
    belongs_to :problem, ProblemService.Schema.Problem
    # belongs_to :discussion, ProblemService.Schema.Discussion
    # belongs_to :answer, ProblemService.Schema.Answer
    belongs_to :idea, ProblemService.Schema.Idea

    timestamps()
  end

  @doc false
  def changeset(vote, attrs) do
    owner = [
      # :solution_id,
      :idea_id,
      :problem_id,
      # :discussion_id,
      # :answer_id
    ]
    vote
    |> cast(attrs, [:user_id] ++ owner)
    |> validate_required([:user_id])
    |> Util.EctoUtil.validate_required_inclusion(owner)
  end
end
