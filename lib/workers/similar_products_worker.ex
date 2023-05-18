defmodule ProblemService.Workers.SimilarProductsWorker do
  use Que.Worker, concurrency: 10
  alias ProblemService.ProductRepo
  alias ProblemService.ProblemRepo
  alias ProblemService.Web.Endpoint

  def perform(%{problem_id: problem_id, user_id: user_id, identifier: identifier}) do
    Endpoint.broadcast("problem:#{problem_id}", "ai:products", %{problem_id: problem_id})

    with problem <- ProblemRepo.get(problem_id),
         {:ok, similar} <- Openai.SimilarProducts.generate(problem.overview) do
      IO.inspect(similar)

      Enum.each(similar["products"], fn product ->
        ProductRepo.insert!(%{
          name: product["name"],
          url: product["url"],
          description: product["description"],
          match_percent: product["match_percent"],
          crunchbaseURL: product["crunchbaseURL"],
          productHuntUrl: product["productHuntUrl"],
          problem_id: problem.id,
          user_id: user_id
        })

        Endpoint.broadcast("problem:#{problem.id}", "reload:products", %{ok: :ok})
      end)
    end
  end
end
