defmodule ProblemService.SolutionRepo do
  use ProblemService.SchemaRepo, schema: ProblemService.Schema.Solution

  def for_problem(problem_id, preloads \\ []) do
    from(p in Solution,
      where: p.problem_id == ^problem_id,
      select: p
    )
    |> one(preloads)
  end
end
