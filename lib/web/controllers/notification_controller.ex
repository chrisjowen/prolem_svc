defmodule ProblemService.NotificationController do
  use ProblemService.BaseController, schema: ProblemService.Schema.Notification

  def index(conn, params),
    do: super(assign(conn, :q, "to_id=#{current_resource(conn).id}"), params)

end
