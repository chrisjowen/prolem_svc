defmodule ProblemService.LinkController do
  use ProblemService.BaseController, schema: ProblemService.Schema.Link

  plug ProblemService.SetQuery, only: [:index]

  # def create(conn, %{"url" => url} = params) do
  #   with {:ok, screenshot} <- Util.Screenshot.capture_and_store(url) do
  #     super(conn, Map.put(params, "screenshot", screenshot))
  #   end
  # end

  # def update(conn, %{"url" => url} = params) do
  #   with {:ok, screenshot} <- Util.Screenshot.capture_and_store(url) do
  #     super(conn, Map.put(params, "screenshot", screenshot))
  #   end
  # end
end
