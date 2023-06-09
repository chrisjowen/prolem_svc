defmodule ProblemService.AnswerController do
  use ProblemService.BaseController, schema: ProblemService.Schema.Answer

  def index(conn, %{"discussion_id" => discussion_id} = params) do
   super(assign(conn, :q, "discussion_id=#{discussion_id}"), params)
  end

end
