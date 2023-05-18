defmodule ProblemService.IdeaRepo do
  use ProblemService.SchemaRepo, schema: ProblemService.Schema.Idea

  def all_for_sector(sector_id, preloads \\ []) do
    from(p in Idea,
      where: p.sector_id == ^sector_id,
      select: p
    )
    |> all(%{}, preloads)
  end
end
