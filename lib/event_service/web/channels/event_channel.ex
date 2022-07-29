defmodule EventService.EventChannel do
  use Phoenix.Channel
  alias EventService.EventChatRepo

  def join("event:" <> event_id, _params, socket) do
    {event_id, _} = Integer.parse(event_id)
    {:ok, assign(socket, :current_event, event_id)}
  end

  def handle_in("msg", %{"body" => body}, socket) do
    with {:ok, message} <-
           EventChatRepo.insert(%{
             event_id: socket.assigns[:current_event],
             user_id: socket.assigns[:current_user],
             msg: body
           }),
         message <- EventChatRepo.get(message.id, [:user]) do
      broadcast!(socket, "msg", message)
      {:noreply, socket}
    end
  end
end
