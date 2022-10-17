defmodule Totem.EventRepo do
  use Totem.SchemaRepo, schema: Totem.Schema.Event
  import Geo.PostGIS
  import Ecto.Query
  require Ecto.Query
  import PhoenixApiToolkit.Ecto.DynamicFilters


  @filter_definitions [
    atom_keys: true,
    string_keys: true,
    order_by: true,
    equal_to_any: [:type_id],
    equal_to: [:type_id],
    greater_than_or_equal_to: [
      starts_after: :start,
    ],
    smaller_than: [
      starts_before: :start
    ],
  ]

  def within_distance(point, distance), do: within_distance(@this, point, distance)

  def within_distance(query, point, distance) do
    from q in query,
      where: st_distance(q.location, ^point)  < ^distance,
      select: %{q | distance: st_distance(q.location, ^point) },
      order_by: st_distance(q.location, ^point)
  end

  def resolve_binding(query, _) do
    query
  end

  def with_filters(filters), do: with_filters(@this, filters)
  def with_filters(query, filters) do
    schema = %{starts_after: :naive_datetime, starts_before: :naive_datetime,  type_id: {:array, :integer}}
    cs = Ecto.Changeset.cast({%{},schema}, filters, Map.keys(schema)) |> IO.inspect

    from(q in query, as: :event)
    |> standard_filters(cs.changes, :event, @filter_definitions, &resolve_binding/2)
  end

end
