defmodule Totem.GroupMediaRepo do
    use Totem.SchemaRepo, schema: Totem.Schema.GroupMedia

    def in_group(group_id) do
      from m in GroupMedia,
      where: m.group_id == ^group_id
    end
  end
