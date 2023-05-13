defmodule Openai.Title do
  def generate(problem) do
    with {:ok, response} <-
           OpenAI.chat_completion(
             model: "gpt-3.5-turbo",
             messages: [
               %{
                 role: "user",
                 content:
                   "Your goal is to summarize a problem statment and give it a short title no more than 5 words"
               },
               %{
                 role: "user",
                 content: hints()
               },
               %{
                 role: "user",
                 content: "
                Given the following problem statement shown between the following tripple backticks:
                    ```#{problem}```.

                Give an example title and a short 100 wrod blurb for the problem statment. Return the following format:
                ```#{format()}```
                "
               }
             ]
           ) do
      [choice | _] = response.choices
      content = choice["message"]["content"]
      {:ok, Jason.decode!(content)}
    end
  end

  defp format(),
    do: """
    The format for the response is defined in following format
    {
      "title": String,
      "blurb": String // 200 characters MAX
    }
    """

  defp hints(),
    do: """
      When doing your job remember:
        - The blurb should be maximum 200 characters long
        - The output should be a VALID JSON OBJECT and nothing else.
        - Check that the response should is parsable by JSON.parse() as is without any preprocessing
        - ONLY VALID JSON, NO OTHER TEXT
    """
end
