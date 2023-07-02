alias ProblemService.Schema.Expert
alias ProblemService.Repo

defmodule Seeder do
  def execute() do
    experts =
      Path.wildcard("/tmp/expert/profile/*.json")
      |> Enum.map(fn path ->
        result = File.read!(path) |> Jason.decode!()
        slug = Path.basename(path, ".json")

        params =
          result
          |> Map.put("slug", slug)
          |> Map.put("expertise", result["categories"])
          |> Map.put("title", result["details"])
          |> Map.put("img", "/experts/#{slug}.jpg")

        case Expert.changeset(%Expert{}, params) |> Repo.insert() do
          {:ok, _} -> IO.inspect("Inserted #{slug}")
          {:error, changeset} -> IO.inspect(changeset.errors)
        end
      end)
  end
end

Seeder.execute()
