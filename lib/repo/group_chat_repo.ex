defmodule Totem.GroupChatRepo do
  use Totem.SchemaRepo, schema: Totem.Schema.GroupChat

  def latest(group_id) do
    q =
      from c in GroupChat,
        where: c.group_id == ^group_id,
        order_by: [asc: c.inserted_at]

    q |> Repo.all() |> Repo.preload([:user, :media])
  end
end
