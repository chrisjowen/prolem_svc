defmodule Totem.Workers.UserFollowsProcessor do
  use Que.Worker
  alias Totem.UserFollowRepo
  alias Totem.NotificationRepo

  def perform(follow: follow) do
    UserFollowRepo.get(follow.id, [:to, :user]) |> notify_offine_users
  end

  defp notify_offine_users(follow) do
    notification = %{
      type: "UserFollow",
      title: "You have a new follower",
      message: "[mention:#{follow.user.id}] is now following you",
      actions: [
        %{
          title: "View Profile",
          path: "/profile/#{follow.user.id}"
        }
      ]
    }

    NotificationRepo.insert!(Map.put(notification, :user_id, follow.to.id))
    TotemWeb.Endpoint.broadcast!("user:#{follow.to.id}", "notification", notification)
  end


end
