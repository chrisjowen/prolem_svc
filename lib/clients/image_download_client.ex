defmodule ProblemService.Clients.ImageDownloadClient do
  def download(url, path) do
    case HTTPoison.get(url, [], timeout: 50_000, recv_timeout: 50_000) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        File.write!(path, body)
        {:ok, path}

      {:ok, %HTTPoison.Response{status_code: 404}} ->
        {:error, "not found"}

      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, reason}
    end
  end
end
