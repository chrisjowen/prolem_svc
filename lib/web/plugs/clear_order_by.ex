defmodule ProblemService.ClearOrderBy do
  import Plug.Conn

  def init(default), do: default

  def call(conn, order_by) do
    assign(conn, :order_by, "")
  end
end
