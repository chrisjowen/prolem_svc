defmodule ProblemService.LinkController do
  use ProblemService.BaseController, schema: ProblemService.Schema.Link

  plug ProblemService.SetQuery, only: [:index]

end
