defmodule ProblemService.UserSocket do
  use Phoenix.Socket

  # channel "user:*", ProblemService.UserChannel


  channel "user:*", ProblemService.UserChannel


  # See `Phoenix.Token` documentation for examples in
  # performing token verification on connect.
  @impl true
  def connect(_params, socket, _info) do
    # case ProblemService.Guardian.resource_from_token(params["token"]) do
    #   {:ok, user, _} when not is_nil(user) ->
    #     {:ok, assign(socket, :current_user, user.id)}
    #   _ ->
    #     {:ok, socket}
    # end
    {:ok, socket}
  end

  # Socket id's are topics that allow you to identify all sockets for a given user:
  #
  #     def id(socket), do: "user_socket:#{socket.assigns.user_id}"
  #
  # Would allow you to broadcast a "disconnect" event and terminate
  # all active sockets and channels for a given user:
  #
  #     Elixir.ProblemService.Web.Endpoint.broadcast("user_socket:#{user.id}", "disconnect", %{})
  #
  # Returning `nil` makes this socket anonymous.
  @impl true
  def id(_socket), do: nil
end
