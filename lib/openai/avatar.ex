defmodule Openai.Persona.Avatar do
  def generate(persona) do

    prompt = "Linked in profile photo for: #{persona["name"]}, ethinicity #{persona["ethnicity"]}, age #{persona["age"]}, gender: #{persona["gender"]}, appearance: #{persona["descriptionOfAppearance"]}"

    with {:ok, response} <-
      OpenAI.images_generations(
        [prompt: prompt, size: "256x256"],
        %OpenAI.Config{http_options: [recv_timeout: 10 * 60 * 1000]} # optional!
     ) do
      [h|_] = response.data
      h
    else
      {:error, error} ->
        # #IO.inspect(error)
        %{"error" => :timeout}
    end
  end

end
