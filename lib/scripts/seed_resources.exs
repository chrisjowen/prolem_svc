alias ProblemService.Schema.Problem
alias ProblemService.Schema.Obstacle
alias ProblemService.Repo

defmodule Seeder do
  @baseUrl "http://problem.chrisjowen.net"

  def execute() do

    problem = HTTPoison.get!("#{@baseUrl}/api/problem?page_size=1000&preloads=sector").body
    |> Jason.decode!()


    problem["entries"]
    |> Enum.each(&generate_resources/1)
  end
  def generate_resources(problem) do
    Task.async(fn ->
      baseUrl = "http://problem.chrisjowen.net"
      # baseUrl = "http://127.0.0.1:5173"

      IO.inspect("Creating resources for: #{problem["title"]}")

      token =
        "eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJwcm9ibGVtX3NlcnZpY2UiLCJleHAiOjE2ODg3MTkwNzIsImlhdCI6MTY4NjI5OTg3MiwiaXNzIjoicHJvYmxlbV9zZXJ2aWNlIiwianRpIjoiMTBmNGIzNGEtNWFkZC00Y2ZjLTg1NWQtYjg4ZDFkOTg0YWIxIiwibmJmIjoxNjg2Mjk5ODcxLCJzdWIiOiIxIiwidHlwIjoiYWNjZXNzIn0.2jeUnFNcrFytrhFfU0ono-rf5fZVa0QpPt0YIwqL9TwueJ9blsdx8JqUztzf4U5bmsXg_xYOSNiwEPwUmkgNXA"

      headers = [Authorization: "Bearer #{token}", "Content-Type": "application/json"]

      HTTPoison.post!("#{baseUrl}/api/workflow/problem_resources", Jason.encode!(%{
        "problem_id" => problem["id"],
      }), headers,
        timeout: 50_000,
        recv_timeout: 50_000
      )
    end)
  end
end

Seeder.execute()
