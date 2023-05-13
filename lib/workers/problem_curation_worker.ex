defmodule ProblemService.Workers.ProblemCurationWorker do
  use Que.Worker
  alias ProblemService.Web.Endpoint
  alias ProblemService.ProblemRepo

  def perform(%{problem: raw, user_id: user_id, identifier: identifier}) do
    with {:ok, statement} <- Openai.Statement.generate(raw),
         {:ok, %{"title" => title, "blurb" => blurb}} <- Openai.Title.generate(statement),
         #  {:ok, image} <- Openai.Image.generate("Banner image for problem: #{blurb}"),
         {:ok, problem} <-
           ProblemRepo.insert(%{
             title: title,
             blurb: blurb,
             overview: statement,
             slug: title |> String.downcase() |> String.replace(" ", "_")
           }) do
      enqueue_workers(problem, user_id, identifier)
      Endpoint.broadcast("problem:uid-#{identifier}", "created:problem", %{problem_id: problem.id})
    end
  end

  def enqueue_workers(problem, user_id, identifier) do
    params = %{
      problem_id: problem.id,
      user_id: user_id,
      identifier: identifier
    }
    [
      ProblemService.Workers.SimilarProductsWorker,
      ProblemService.Workers.StakeholdersWorker,
      ProblemService.Workers.SolutionWorker
    ]
    |> Enum.each(&Que.add(&1, params))
  end
end
