defmodule Totem.GroupSocket do
  use Phoenix.Socket

  channel "group:*", Totem.GroupChannel
  channel "user:*", Totem.UserChannel

  # See `Phoenix.Token` documentation for examples in
  # performing token verification on connect.
  @impl true
  def connect(params, socket, _info) do

    IO.inspect( Totem.Guardian.resource_from_token(params["token"]))
    case Totem.Guardian.resource_from_token(params["token"]) do
      {:ok, user, _} ->
        {:ok, assign(socket, :current_user, user.id)}
      {:error, _error} ->
        {:ok, socket}
    end
  end

  # Socket id's are topics that allow you to identify all sockets for a given user:
  #
  #     def id(socket), do: "user_socket:#{socket.assigns.user_id}"
  #
  # Would allow you to broadcast a "disconnect" event and terminate
  # all active sockets and channels for a given user:
  #
  #     Elixir.TotemWeb.Endpoint.broadcast("user_socket:#{user.id}", "disconnect", %{})
  #
  # Returning `nil` makes this socket anonymous.
  @impl true
  def id(_socket), do: nil
end
