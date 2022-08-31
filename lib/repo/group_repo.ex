defmodule Totem.GroupRepo do
  use Totem.SchemaRepo, schema: Totem.Schema.Group
  import Geo.PostGIS
  alias Ecto.Multi
  alias Totem.Schema.GroupTag
  alias Totem.Schema
  def within_distance(point, distance), do: within_distance(@this, point, distance)

  def within_distance(query, point, distance) do
    from q in query,
      where: st_distance(q.location, ^point) < ^distance
  end

  def insert(params) do
    Multi.new()
    |> Multi.insert(:group, @this.changeset(%@this{}, params))
    |> Multi.insert_all(:tags, GroupTag, fn %{group: group} ->
      params["tags"] |> Enum.map(&%{group_id: group.id, tag_id: &1})
    end)
    |> Repo.transaction()
  end

  def get_with_expansions(id, _expansions) do
    Repo.one(
      from e in Schema.Group,
        as: :group,
        left_join: c in assoc(e, :chats),
        left_lateral_join:
          top_five in subquery(
            from Schema.GroupChat,
              where: [group_id: parent_as(:group).id],
              limit: 4,
              select: [:id]
          ),
        on: top_five.id == c.id,
        where: e.id == ^id,
        preload: [{:chats, {c, :user}}, :user, :media]
    )
  end
end
