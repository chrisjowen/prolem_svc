defmodule Totem.UserChannel do
  use Phoenix.Channel
  alias Totem.GroupChatRepo

  def join("user:" <> user_id, _params, socket) do
    {:ok, socket}
  end

end
