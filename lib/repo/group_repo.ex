defmodule Totem.GroupRepo do
  use Totem.SchemaRepo, schema: Totem.Schema.Group
  import Geo.PostGIS
  alias Ecto.Multi

  def with_active(query) do
    time = 60 * 60 * 24
    duration = NaiveDateTime.utc_now() |> NaiveDateTime.add(-time, :second)

    from group in query,
      where: group.updated_at >= ^duration
  end

  def with_filters(query, filters) do
    group_types = Map.get(filters, "groupsTypes")

    case group_types do
      types when is_list(types) and length(types) > 0 ->
        from q in query,
          where: q.type_id in ^types
      _ ->
        query
    end
  end

  def within_distance(point, distance), do: within_distance(@this, point, distance)

  def within_distance(query, point, distance) do
    from q in query,
      where: st_distance(q.location, ^point) < ^distance
  end

  def insert(params) do
    Multi.new()
    |> Multi.insert(:group, @this.changeset(%@this{}, params))
    |> Repo.transaction()
  end
end
