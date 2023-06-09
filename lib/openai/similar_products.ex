defmodule Openai.SimilarProducts do
  def generate(problem) do
    #IO.inspect(problem)

    with {:ok, response} <-
           OpenAI.chat_completion(
             model: "gpt-3.5-turbo",
             messages: [
               %{
                 role: "user",
                 content:
                   "Your goal is to suggest existing known products that fit a problem statement "
               },
               %{
                 role: "user",
                 content: format()
               },
               %{
                role: "user",
                content: advice()
              },
               %{
                 role: "user",
                 content: "
                Given the following problem statement stated between the following tripple backticks:
                    ```#{problem}```.

                Based on your current knowlagde suggest products that may attempt to solve this problem using the format specified.
                "
               }
             ]
           ) do
      [choice | _] = response.choices
      content = choice["message"]["content"]
      {:ok, Jason.decode!(content)}
    else
      {:error, error} ->
        #IO.inspect(error)
        {:error, error}
    end
  end

  defp format(),
    do: """
    { "products" : [
      {
        "name": String,
        "url": String,
        "description": String (max length 100),
        "match_percent": Int (1-100 - percentage this product matches the problem statement),
        "crunchbaseSlug": String (optional),
        "crunchbaseURL": String (optional),
        "productHuntUrl": String (optional),
        "productHuntId": String (optional)
      }
    ]
    }
    """

  defp advice(),
    do: """
    When performing this task:

      - The output should be a VALID JSON OBJECT and NOTHING ELSE!
      - Again, confirm the entire response you will provide is parsable by JSON.parse() without any preprocessing
      - If not try again and ensure these criteria are met this time
      - Return the most relevent  results only (max 5) based on how much this product matches the problem statement
      - Ensure that the url is valid 200 and exists
    """
end
