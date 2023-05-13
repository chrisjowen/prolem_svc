defmodule ProblemService.ProductRepo do
  use ProblemService.SchemaRepo, schema: ProblemService.Schema.Product

  def all_for_problem(problem_id, preloads \\ []) do
    from(p in Product,
      where: p.problem_id == ^problem_id,
      select: p
    )
    |> all(preloads)
  end
end
