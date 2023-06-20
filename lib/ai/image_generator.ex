defmodule Ai.ImageGenerator do
  def execute(prompt, size \\ :mid) do
    dimensions =
      case size do
        :small -> "512x512"
        :mid -> "512x512"
        :large -> "512x512"
      end

    with {:ok, response} <-
           OpenAI.images_generations(
             [prompt: prompt, size: dimensions],
             %OpenAI.Config{http_options: [recv_timeout: 10 * 60 * 1000]}
           ) do
      [h | _] = response.data
      {:ok, response.data}
    end
  end
end
