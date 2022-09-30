defmodule Totem.EventRepo do
  use Totem.SchemaRepo, schema: Totem.Schema.Event
  import Geo.PostGIS


  def within_distance(point, distance), do: within_distance(@this, point, distance)

  def within_distance(query, point, distance) do
    from q in query,
      where: st_distance(q.location, ^point) < ^distance
  end

end
