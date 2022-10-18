defmodule Totem.UserChannel do
  use Phoenix.Channel
  alias Phoenix.Socket.Broadcast

  def join("user:" <> user_id, _params, socket) do
    {:ok, socket
        |> assign(:topics, [])
      }
  end


  def handle_in("watch", %{"id" => id}, socket) do
    IO.inspect("Wathing group:#{id}")
    {:reply, :ok, put_new_topics(socket, ["group:#{id}"])}
  end

  def handle_in("unwatch", %{"id" => id}, _socket) do
    {:reply, :ok, TotemWeb.Endpoint.unsubscribe("group:#{id}")}
  end

  defp put_new_topics(socket, topics) do
    Enum.reduce(topics, socket, fn topic, acc ->
      topics = acc.assigns.topics
      if topic in topics do
        acc
      else
        :ok = TotemWeb.Endpoint.subscribe(topic)
        assign(acc, :topics, [topic | topics])
      end
    end)
  end

  def handle_info(%Broadcast{topic: _, event: event, payload: payload}, socket) do
    push(socket, event, payload)
    {:noreply, socket}
  end

end
