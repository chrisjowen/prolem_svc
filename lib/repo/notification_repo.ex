defmodule Totem.NotificationRepo do
  use Totem.SchemaRepo, schema: Totem.Schema.Notification

  def with_user(user_id), do: with_user(@this, user_id)

  def with_user(query, user_id) do
    from n in query,
      where: n.user_id == ^user_id
  end
end
