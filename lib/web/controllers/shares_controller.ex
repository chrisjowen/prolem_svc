defmodule Totem.ShareController do
  use Totem.BaseController
  alias Totem.NotificationRepo
  alias Totem.UserRepo
  alias Totem.GroupRepo
  alias Totem.GroupInviteRepo

  def create(conn, %{"shares" => shares}) do
    sender = current_resource(conn)
    IO.inspect(shares)
    Enum.map(shares, fn share ->
      case share["type"] do
        "Follow" -> sendFollowNotifications(sender, share)
        "Group" -> sendGroupNotifications(sender, share)
        _ -> IO.inspect("Unknown share")
      end
    end)
    json(conn, :ok)
  end

  defp sendFollowNotifications(sender, %{"user" => user_id}) do
    notification = %{
      type: "FriendJoined",
      title: "A Friend You Invited Joined RedDotz",
      message: "[mention:#{sender.id}]  joined RedDotz",
      actions: [
        %{
          title: "View Profile",
          path: "/profile/#{sender.id}"
        }
      ]
    }
    NotificationRepo.insert!(Map.put(notification, :user_id, user_id))
    TotemWeb.Endpoint.broadcast!("user:#{user_id}", "notification", notification)
  end

  defp sendGroupNotifications(sender, %{"user" => user_id, "group" => group_id}) do
    from  = UserRepo.get(user_id)
    group  = GroupRepo.get(group_id)

    send_and_store_notificaton(from.id, %{
        type: "FriendJoined",
        title: "A Friend You Invited Joined RedDotz",
        message: "[mention:#{sender.id}] joined RedDotz",
        actions: [
          %{
            title: "View Profile",
            path: "/profile/#{sender.id}"
          }
        ]
      })

      create_and_send_group_invite(group, sender, from)
  end

  defp create_and_send_group_invite(group, to, from) do
    notification = %{
      type: "UserInvited",
      title: "Invite to Group #{group.title}",
      message: "[mention:#{from.id}] invited you to group #{group.title}",
      actions: [
        %{
          title: "View Group",
          path: "/group/#{group.id}"
        }
      ]
    }
    invite = %{
      user_id: from.id,
      to_id: to.id,
      group_id: group.id,
    }
    with {:ok, invite} <- GroupInviteRepo.insert(invite) do
      send_and_store_notificaton(to.id, notification)
    end
  end

  defp send_and_store_notificaton(to_id, notification) do
    NotificationRepo.insert!(Map.put(notification, :user_id, to_id))
    TotemWeb.Endpoint.broadcast!("user:#{to_id}", "notification", notification)
  end

end
