defmodule ProblemService.Schema.Discussion do
  use Ecto.Schema
  import Ecto.Changeset

  schema "discussions" do
    field :question, :string
    field :title, :string
    belongs_to :user, ProblemService.Schema.User
    belongs_to :solution, ProblemService.Schema.Solution
    belongs_to :problem, ProblemService.Schema.Problem
    belongs_to :updated_by, ProblemService.Schema.User
    has_many :answers, ProblemService.Schema.Answer
    timestamps()
  end

  @doc false
  def changeset(question, attrs) do
    question
    |> cast(attrs, [:title, :question, :user_id, :solution_id, :problem_id, :updated_by_id])
    |> validate_required([:title, :question, :user_id])
    |> Util.EctoUtil.validate_required_inclusion([:solution_id, :problem_id])
  end
end
