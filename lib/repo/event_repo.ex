defmodule Totem.EventRepo do
  use Totem.SchemaRepo, schema: Totem.Schema.Event
  import Geo.PostGIS
  import Ecto.Query
  require Ecto.Query
  import PhoenixApiToolkit.Ecto.DynamicFilters
  alias Ecto.Multi
  alias Totem.Schema

  @filter_definitions [
    atom_keys: true,
    string_keys: true,
    order_by: true,
    equal_to_any: [:type_id],
    equal_to: [:type_id]
  ]

  def insert(params) do
    Multi.new()
    |> Multi.insert(:event, @this.changeset(%@this{}, params))
    |> Multi.insert_all(:dates, Schema.EventDate, fn %{event: event} ->
      dates = Map.get(params, "dates", [])
      dates |> Enum.map(&insert_event_date(event, &1))
    end)
    |> Repo.transaction()
  end

  defp insert_event_date(event, date) do
    cs = Schema.EventDate.changeset(%{
      event_id: event.id,
      start: date["start"],
      end: date["end"],
    })
    cs.changes
  end

  def within_distance(point, distance), do: within_distance(@this, point, distance)

  def within_distance(query, point, distance) do
    from q in query,
      where: st_distance(q.location, ^point)  < ^distance,
      select: %{q | distance: st_distance(q.location, ^point) },
      order_by: st_distance(q.location, ^point)
  end

  def resolve_binding(query, _any) do
    query
  end

  def with_greater_than_or_equal_to(query, value) do
    sq = from ed in Schema.EventDate,
    where: ed.start >= ^value,
    distinct: ed.event_id,
    select: ed.event_id

    from q in query,
    where: q.id in subquery(sq)
  end

  def with_smaller_than(query, value) do
    sq = from ed in Schema.EventDate,
      where: ed.end <= ^value,
      distinct: ed.event_id,
      select: ed.event_id

      from q in query,
      where: q.id in subquery(sq)


    # where(query, [event_date: event_date], event_date.end <= ^value)
  end

  def with_filters(filters), do: with_filters(@this, filters)
  def with_filters(query, filters) do
    schema = %{starts_after: :naive_datetime, starts_before: :naive_datetime,  type_id: {:array, :integer}}
    cs = Ecto.Changeset.cast({%{},schema}, filters, Map.keys(schema))

    from(q in query, as: :event)
    |> standard_filters cs.changes, :event, @filter_definitions, &resolve_binding/2 do
      {:starts_after,value}, query -> with_greater_than_or_equal_to(query, value)
      {:starts_before,value}, query -> with_smaller_than(query, value)
    end
  end
end
