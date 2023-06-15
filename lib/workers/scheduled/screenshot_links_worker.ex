defmodule ProblemService.Workers.ScreenshotLinksWorker do
  use Que.Worker, concurrency: 1
  alias ProblemService.Web.Endpoint
  alias ProblemService.Repo
  alias ProblemService.Schema.Link
  require Logger

  def perform(%{link: link}) do
    capture_screenshot(link)
  end

  # def perform(_ \\ nil) do
  #   # Link.without_screenshot()
  #   Link.for_problem(215)
  #   |> Repo.all()
  #   |> Enum.each(fn link ->
  #     Que.add(__MODULE__, %{link: link})
  #   end)
  # end

  defp capture_screenshot(link) do
    IO.inspecgt(link)
    with {:ok, path} <- Util.Screenshot.capture_and_store(link.url) do
      link
      |> Link.changeset(%{screenshot: path})
      |> Repo.update!()
      |> IO.inspect()
    else
      error -> Logger.error(error)
    end
  end
end
