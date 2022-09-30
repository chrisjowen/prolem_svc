defmodule Totem.Workers.GroupMemberEventProcessor do
  use Que.Worker
  alias Totem.GroupRepo
  alias Totem.UserRepo
  alias Totem.NotificationRepo
  alias Totem.GroupChatRepo

  def perform(group_id: group_id, user_id: user_id, sender_id: sender_id) do
    group = GroupRepo.get(group_id, [:group_members])
    user = UserRepo.get(user_id)
    notify_offine_users(group, user, sender_id)
    add_to_group_chat(group, user)
  end

  defp add_to_group_chat(group, user) do
    {:ok, message} =
      GroupChatRepo.insert(%{
        group_id: group.id,
        user_id: user.id,
        msg: "#{user.name} #{user.last_name} joined the group"
      })

    message = GroupChatRepo.get(message.id, [:user, :media])
    TotemWeb.Endpoint.broadcast!("group:#{group.id}", "msg", message)
  end

  defp notify_offine_users(group, user, sender_id) do
    notification = %{
      type: "UserJoined",
      title: "#{user.name} #{user.last_name} joined group #{group.title}",
      message: """
        #{user.name} #{user.last_name} just joined a group your in named #{group.title},
        go introduce yourself and start chatting now
      """,
      actions: [
        %{
          title: "View Group",
          path: "/group/#{group.id}"
        }
      ]
    }

    (Enum.map(group.group_members, fn m -> m.user_id end) ++ [group.user_id])
    |> Enum.filter(fn id -> sender_id != id end)
    |> Enum.each(&send_notification(&1, notification))
  end

  defp send_notification(user_id, notification) do
    NotificationRepo.insert!(Map.put(notification, :user_id, user_id))
    TotemWeb.Endpoint.broadcast!("user:#{user_id}", "notification", notification)
  end
end
