defmodule ProblemService.Clients.Experts.ExpertFinderClient do
  @endpoint "https://expertisefinder.com"

  alias ProblemService.Clients.Experts.ExpertFinderProfileExtractor

  def categories() do
    with {:ok, %HTTPoison.Response{status_code: 200, body: body}} <-
           HTTPoison.get(@endpoint <> "/find-an-expert/", [],
             timeout: 50_000,
             recv_timeout: 50_000
           ),
         {:ok, document} <- Floki.parse_document(body) do
      results =
        Floki.find(document, ".az-columns a")
        |> Enum.map(fn element ->
          [href | _] = Floki.attribute(element, "href")

          category =
            String.replace(href, "#{@endpoint}/find-an-expert/", "") |> String.replace("/", "")

          %{
            name: String.trim(Floki.text(element)),
            url: href,
            category: category
          }
        end)

      {:ok, results}
    end
  end

  def experts(category) do
    path = "#{@endpoint}/find-an-expert/#{category}/"

    IO.inspect("Searching for experts in #{path}")

    with {:ok, %HTTPoison.Response{status_code: 200, body: body}} <-
           HTTPoison.get(path, [],
             timeout: 50_000,
             recv_timeout: 50_000
           ),
         {:ok, document} <- Floki.parse_document(body) do
      results =
        Floki.find(document, ".elementor-button-wrapper a")
        |> Enum.map(fn element -> List.first(Floki.attribute(element, "href"), "") end)
        |> Enum.filter(fn url -> String.contains?(url, "/experts/") end)
        |> Enum.map(fn url ->
          url
          |> String.replace("https://network.expertisefinder.com/experts/", "")
          |> String.replace("/", "")
        end)

      IO.inspect("found #{length(results)} experts")
      {:ok, results}
    end
  end

  def expert(profile) do
    path = "https://network.expertisefinder.com/experts/#{profile}"
    response = HTTPoison.get(path, [], timeout: 50_000, recv_timeout: 50_000)

    with {:ok, %HTTPoison.Response{status_code: 200, body: body}} <- response,
         {:ok, document} <- Floki.parse_document(body) do
      {:ok, ExpertFinderProfileExtractor.extract(document)}
    else
      {:ok, %HTTPoison.Response{status_code: code}} -> {:error, "HTTP Error #{profile}: #{code}"}
      e -> {:error, "Unknown error #{profile}:  #{inspect(e)}"}
    end
  end
end
