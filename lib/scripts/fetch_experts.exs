alias ProblemService.Repo
alias ProblemService.Clients.Experts.ExpertFinderClient
alias ProblemService.Clients.ImageDownloadClient

defmodule Seeder do
  @out "/tmp/expert"

  def download_images() do
    experts = Path.wildcard("/tmp/expert/profile/*.json")
    |> Enum.map(fn path ->
      result = File.read!(path) |> Jason.decode!()
      Map.put(result, "slug", Path.basename(path, ".json"))
    end)

    experts
    |> Enum.each(fn expert ->
      case expert["image"] do
        nil -> IO.inspect("No image for #{expert["slug"]}")
        image -> ImageDownloadClient.download(image, "/tmp/expert/images/#{expert["slug"]}.jpg")
      end
    end)
  end

  def execute() do
    experts = File.read!("#{@out}/all.json") |> Jason.decode!()

    tasks =
      experts
      |> Enum.map(fn expert ->
        Task.async(fn ->
          try do
            with {:ok, profile} <- ExpertFinderClient.expert(expert) do
              path = "#{@out}/profile/#{expert}.json"
              # IO.inspect("Wriring #{path} ")
              File.write!(path, Jason.encode!(profile))
            else
              e -> IO.inspect(e)
            end
          rescue
            e -> IO.inspect(e)
          end
        end)
      end)

    Task.await_many(tasks, 100_000)

    IO.inspect("COMPLETE")
  end

  def combine() do
    all =
      Path.wildcard("/tmp/expert/*.experts.json")
      |> Enum.flat_map(fn path ->
        File.read!(path) |> Jason.decode!()
      end)
      |> Enum.uniq()

    File.write!("#{@out}/all.json", Jason.encode!(all))
  end

  def fetch_expert_names() do
    {:ok, categories} = ExpertFinderClient.categories()

    tasks =
      categories
      |> Enum.map(fn cat ->
        Task.async(fn ->
          try do
            {:ok, experts} = ExpertFinderClient.experts(cat.category)
            File.write!("#{@out}/#{cat.category}.experts.json", Jason.encode!(experts))
          rescue
            e -> IO.inspect(e)
          end
        end)
      end)

    Task.await_many(tasks, 100_000)

    #   assert length(categories) > 0}
  end
end

Seeder.execute()
