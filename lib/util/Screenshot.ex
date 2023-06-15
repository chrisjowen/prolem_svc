defmodule Util.Screenshot do
  @screen_shot_api_token "https://shot.screenshotapi.net/screenshot"
  import Logger

  def capture_and_store(url) do
    id = Ecto.UUID.generate()
    response = "/screenshots/#{id}.png"
    path = File.cwd!() <> "/resources/images" <> response

    with {:ok, image_url} <- capture(url),
         %HTTPoison.Response{body: body} <-
           HTTPoison.get!(image_url, [],
             timeout: 50_000,
             recv_timeout: 50_000
           ) do
      File.write!(path, body) |> IO.inspect()
      {:ok, response} |> IO.inspect()
    else
      error -> Logger.error(error)
    end
  end

  def capture(url) do
    token = System.get_env("SCREENSHOT_API_KEY")

    params =
      %{
        token: token,
        url: URI.encode_www_form(url),
        # width: 200,
        # height: 200,
        # full_page: true,
        output: "image",
        file_type: "png",
        wait_for_event: "load"
      }
      |> Enum.map(fn {k, v} -> "#{k}=#{v}" end)
      |> Enum.join("&")

    url = "#{@screen_shot_api_token}?#{params}"

    with {:ok, response} <- IO.inspect(HTTPoison.get(url, [])) do
      {"location", location} =
        response.headers
        |> Enum.find(fn {k, _} -> k == "location" end)

      {:ok, location}
    else
      error -> Logger.error(error)
    end
  end
end

# Comment to bounce build

# Util.Screenshot.capture("https://www.google.com")
