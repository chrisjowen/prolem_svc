defmodule Totem.Workers.GroupUserNotifier do
  use Que.Worker
  alias Totem.GroupRepo
  alias Totem.NotificationRepo

  def perform(group_id: group_id, notification: notification) do
    group = GroupRepo.get(group_id, [:group_members])
    group.members
    |> Enum.each(&send_notification(&1.user_id, notification))

    send_notification(group.user_id, notification)
  end

  defp send_notification(user_id, notification) do
    NotificationRepo.insert(Map.put(notification, "user_id", user_id))
  end
end
