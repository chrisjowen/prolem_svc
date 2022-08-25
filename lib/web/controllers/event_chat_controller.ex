defmodule EventService.EventChatController do
  use EventServiceWeb, :controller
  alias EventService.EventChatRepo
  # import Guardian.Plug

  def list(conn, %{"event_id" => id}) do
    json(conn, EventChatRepo.event_latest(id) |> IO.inspect)
  end

end
