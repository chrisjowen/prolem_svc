defmodule Totem.EventRepo do
  use Totem.SchemaRepo, schema: Totem.Schema.Event
  import Geo.PostGIS

  def within_distance(point, distance), do: within_distance(@this, point, distance)

  def within_distance(query, point, distance) do
    from q in query,
      where: st_distance(q.location, ^point)  < ^distance,
      select: %{q | distance: st_distance(q.location, ^point) },
      order_by: st_distance(q.location, ^point)
  end



  def with_filters(query, filters) do
    event_types = Map.get(filters, "eventTypes")

    case event_types do
      types when is_list(types) and length(types) > 0 ->
        from q in query,
          where: q.type_id in ^types
      _ ->
        query
    end
  end


end
