defmodule Totem.GroupMemberRepo do
  use Totem.SchemaRepo, schema: Totem.Schema.GroupMember

  def in_group(group_id) do
    from m in GroupMember,
    where: m.group_id == ^group_id
  end

end
