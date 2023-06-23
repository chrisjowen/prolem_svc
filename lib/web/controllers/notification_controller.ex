defmodule ProblemService.NotificationController do
  use ProblemService.BaseController, schema: ProblemService.Schema.Notification

  def index(conn, params) do
    conn
    |> assign(:q, "to_id=#{current_resource(conn).id}")
    |> assign(:order_by, "inserted_at|desc")
    |> super(params)
  end
end
