defmodule Totem.Workers.GroupInviteEventProcessor do
  use Que.Worker
  alias Totem.GroupRepo
  alias Totem.UserRepo
  alias Totem.GroupChatRepo
  alias Totem.NotificationRepo

  def perform(invite: invite) do
    group = GroupRepo.get(invite.group_id)
    user = UserRepo.get(invite.user_id)
    to = UserRepo.get(invite.to_id)
    add_to_group_chat(group, user, to)
    notify_offine_users(group, user, to)
  end

  defp add_to_group_chat(group, user, to) do
    {:ok, message} =
      GroupChatRepo.insert(%{
        group_id: group.id,
        user_id: user.id,
        msg: "[mention:#{to.id}] was invited to join the group by [mention:#{user.id}] "
      })

    message = GroupChatRepo.get(message.id, [:user, :media])
    TotemWeb.Endpoint.broadcast!("group:#{group.id}", "msg", message)
  end

  defp notify_offine_users(group, user, to) do
    notification = %{
      type: "UserInvited",
      title: "Invite to Group #{group.title}",
      message: "[mention:#{user.id}]  invited you to group #{group.title}",
      actions: [
        %{
          title: "View Group",
          path: "/group/#{group.id}"
        }
      ]
    }
    NotificationRepo.insert!(Map.put(notification, :user_id, to.id))
    TotemWeb.Endpoint.broadcast!("user:#{to.id}", "notification", notification)
  end


end
