defmodule ProblemService.QuestionaireRepo do
  use ProblemService.SchemaRepo, schema: ProblemService.Schema.Questionaire


  def all_for_problem(problem_id, preloads \\ []) do
    from(p in Questionaire,
      where: p.problem_id == ^problem_id,
      select: p
    )
    |> all(%{}, preloads)
  end
end
