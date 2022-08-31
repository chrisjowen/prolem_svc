defmodule Totem.GroupChannel do
  use Phoenix.Channel
  alias Totem.GroupChatRepo

  def join("group:" <> group_id, _params, socket) do
    {group_id, _} = Integer.parse(group_id)
    {:ok, assign(socket, :current_event, group_id)}
  end

  def handle_in("msg", %{"msg" => body} = msg, socket) do
    with {:ok, message} <-
           GroupChatRepo.insert(%{
             group_id: socket.assigns[:current_event],
             user_id: socket.assigns[:current_user],
             media_id: Map.get(msg, "media_id"),
             msg: body
           }),
         message <- GroupChatRepo.get(message.id, [:user, :media]) do
      broadcast!(socket, "msg", message)
      {:noreply, socket}
    end
  end
end
