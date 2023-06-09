defmodule ProblemService.CommentController do
  use ProblemService.BaseController, schema: ProblemService.Schema.Comment

  plug ProblemService.SetQuery, only: [:index]


end
