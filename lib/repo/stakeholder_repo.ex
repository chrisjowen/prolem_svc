defmodule ProblemService.StakeholderRepo do
  use ProblemService.SchemaRepo, schema: ProblemService.Schema.Stakeholder

  def all_for_problem(problem_id, preloads \\ []) do
    from(p in Stakeholder,
      where: p.problem_id == ^problem_id,
      select: p
    )
    |> all(preloads)
  end
end
