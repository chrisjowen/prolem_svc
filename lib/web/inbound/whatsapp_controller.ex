defmodule ProblemService.Inbound.WhatsAppController do
  use ProblemService.BaseController

  def inbound(conn, params) do
    IO.inspect(params)
    conn |> json(%{status: "ok"})
  end



end
