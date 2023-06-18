defmodule ProblemService.ProblemFeedController do
  use ProblemService.BaseController
  alias ProblemService.Services.FeedService

  def index(conn, %{"problem_id" => problem_id}) do
    IO.inspect("HEREHERHEHERHE")
    with {:ok, items} <- FeedService.problem_feed(problem_id) do
      json(conn, items)
    end
  end
end
