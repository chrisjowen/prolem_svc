defmodule Totem.GroupInviteRepo do
  use Totem.SchemaRepo, schema: Totem.Schema.GroupInvite

  def in_group(group_id) do
    from m in GroupInvite,
    where: m.group_id == ^group_id
  end

end
