defmodule ProblemService.ProblemRepo do
  use ProblemService.SchemaRepo, schema: ProblemService.Schema.Problem

  def search(params, preloads \\ []) do
    case params["q"] do
      "" ->
        all(Problem, %{}, preloads)

      q ->
        from(p in Problem,
          where: fragment("to_tsvector(?) @@ plainto_tsquery(?)", p.overview, ^q),
          order_by: fragment("ts_rank(to_tsvector(?), plainto_tsquery(?)) DESC", p.overview, ^q)
        )
        |> all(%{}, preloads)
        |> IO.inspect()
    end

    # TODO: Much better searching, see:
    # - https://www.peterullrich.com/complete-guide-to-full-text-search-with-postgres-and-ecto
    # - https://nathanmlong.com/2018/01/fast-fulltext-search-with-ecto-and-postgresql/
  end

  def all_for_sector(sector_id, preloads \\ []) do
    from(p in Problem,
      where: p.sector_id == ^sector_id,
      select: p
    )
    |> all(%{}, preloads)
  end
end
