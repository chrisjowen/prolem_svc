alias ProblemService.Schema.Sector
alias ProblemService.Repo

defmodule NewsSchedule do
  def execute() do
    sectors = Repo.all(Sector)

    sectors
    # |> Enum.take(1)
    |> Enum.each(&add_schedule/1)
  end

  def add_schedule(sector) do
    Task.async(fn ->
      # baseUrl = "http://localhost:4001"
      baseUrl = "https://www.crowdsolve.ai"
      IO.inspect("Creating feed for: #{sector.name}")
      headers = [ "Content-Type": "application/json"]
      body =
        Jason.encode!(%{
          "tags" => [sector.name]
        })

      IO.inspect(body)
      {:ok, result} = HTTPoison.post("#{baseUrl}/api/schedule", body, headers)
      IO.inspect(result)
    end)
  end
end

NewsSchedule.execute()
