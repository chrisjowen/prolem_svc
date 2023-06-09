defmodule ProblemService.Schema.Answer do
  use Ecto.Schema
  import Ecto.Changeset

  schema "answers" do
    field(:answer, :string)

    belongs_to(:discussion, ProblemService.Schema.Discussion)
    belongs_to(:user, ProblemService.Schema.User)

    timestamps()
  end

  @doc false
  def changeset(answer, attrs) do
    answer
    |> cast(attrs, [:answer, :discussion_id, :user_id])
    |> validate_required([:answer, :discussion_id, :user_id])
  end
end
