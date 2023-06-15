defmodule ProblemService.Schema.Link do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query

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


  def without_screenshot(query \\ __MODULE__) do
    from(l in query, where: is_nil(l.screenshot))
  end


  def for_problem(problem_id), do: for_problem(__MODULE__, problem_id)
  def for_problem(query, problem_id) do
    from(l in query, where: l.problem_id == ^problem_id)
  end

end
