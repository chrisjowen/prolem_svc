defmodule ProblemService.Workers.ProblemImageWorker do
  use Que.Worker, concurrency: 10

  alias ProblemService.Web.Endpoint
  alias ProblemService.ProblemRepo


  def perform( %{
    problem_id: problem_id,
    user_id: user_id,
    identifier: identifier
  }), do: perform(problem_id)

  def perform(id) do
    problem = ProblemRepo.get(id)

    with {:ok, result} <- Openai.ImageDescribe.execute(problem.overview),
         {:ok, image} <- make_image(List.first(result["imagery"])),
         {:ok, path} <- save_image(List.first(image.data)["url"], problem) do
          ProblemRepo.update!(problem, %{img: "/problems/#{problem.id}.png"})
    end
  end

  def make_image(keywords) do
    OpenAI.images_generations(
      [prompt: "A ink sketch of: #{keywords}. NO FONTS OR TEXT. ONLY IMAGES!!!", size: "512x512"],
      %OpenAI.Config{http_options: [recv_timeout: 10 * 60 * 1000]}
    )
  end

  def save_image(url, problem) do
    path =  "problems/#{problem.id}.png"

   with %HTTPoison.Response{body: body} <- HTTPoison.get! url do
        File.write!(File.cwd! <> "/resources/images/#{path}", body)
        {:ok, path}
      end
  end
end
