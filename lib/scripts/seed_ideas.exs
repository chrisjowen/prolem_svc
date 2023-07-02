alias ProblemService.Schema.Problem
alias ProblemService.Schema.Obstacle
alias ProblemService.Repo

defmodule Seeder do
  @url "https://www.crowdsolve.ai"

  def execute() do
    sectors =
      HTTPoison.get!("#{@url}/api/sector?page_size=1000").body
      |> Jason.decode!()

    sectors["entries"]
    # |> Enum.take(1)
    |> Enum.each(&queue_ideas/1)
  end

  def queue_ideas(sector) do
    Task.async(fn ->
      token =
        "eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJwcm9ibGVtX3NlcnZpY2UiLCJleHAiOjE2OTAyOTUyMTIsImlhdCI6MTY4Nzg3NjAxMiwiaXNzIjoicHJvYmxlbV9zZXJ2aWNlIiwianRpIjoiOTAyMzdhZGEtZWJlYi00MWQ5LWIwYWQtMjRmMWRhYzFjNDA4IiwibmJmIjoxNjg3ODc2MDExLCJzdWIiOiIxIiwidHlwIjoiYWNjZXNzIn0.WuNYdME4iuTByRQfx5kvqFF41lNwHIwfMrTv6ivMlng8iVYKvkK-wLWBViwdxtIUOyW7IblnPp-gkE7_voM1mQ"

      headers = [Authorization: "Bearer #{token}", "Content-Type": "application/json"]

      HTTPoison.post!(
        "#{@url}/api/workflow/ideas",
        Jason.encode!(%{
          "sector_id" => sector["id"]
        }),
        headers,
        timeout: 50_000,
        recv_timeout: 50_000
      )
    end)
  end
end

Seeder.execute()
