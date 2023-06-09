
alias ProblemService.Schema.ProblemSuggestion
alias ProblemService.Repo



defmodule ProblemSeeder do

    def one() do
        [suggestion | _] = Repo.all(ProblemSuggestion) |> IO.inspect
        generate_template(suggestion)
    end

    def generate_template(suggestion) do
        IO.inspect("Creating problem statement: #{suggestion.title}")
        token = "eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJwcm9ibGVtX3NlcnZpY2UiLCJleHAiOjE2ODg3MzQ3MzUsImlhdCI6MTY4NjMxNTUzNSwiaXNzIjoicHJvYmxlbV9zZXJ2aWNlIiwianRpIjoiODdhYjE3YjYtMmI0MC00M2QyLTkxZWUtYjJmMDg2YzE3YWQ0IiwibmJmIjoxNjg2MzE1NTM0LCJzdWIiOiIxNiIsInR5cCI6ImFjY2VzcyJ9.VV_wxhGqxICh6YJ3NziIKPlfgJj_79o7OKKO69OXvCXkCJjEvKuc8BW_M2X8vKAhWXIk329nUUIWxIOlpPgg8A"
        headers = ["Authorization": "Bearer #{token}", "Content-Type": "application/json"]
        body =  %{
            "sector_id" => suggestion.sector_id,
            "statement" => "#{suggestion.title} - #{suggestion.blurb}"
        }
        HTTPoison.post!("http://problem.chrisjowen.net/api/workflow/template", Jason.encode!(body), headers)
    end

end


ProblemSeeder.one()
