defmodule Openai.Questionaire do
  def generate(problem, stakeholder) do
    with {:ok, response} <-
           OpenAI.chat_completion(
             model: "gpt-3.5-turbo",
             messages: [
               %{
                 role: "user",
                 content:
                   "Your goal is to devise a questionaire based on a problem statement, and a stakeholder persona to better understand their problems "
               },
               %{
                 role: "user",
                 content: format()
               },
               %{
                 role: "user",
                 content: "
                Now analyse the following problem statement shown between the following tripple backticks:
                    ```#{problem}```.

                And consider the stakeholder persona in the following tripple backticks:
                    ```#{stakeholder}```.

                You expected response format you should provide is between the following tripple backticks:
                    ```#{format()}```

                When performing this task

                    - The output should be a VALID JSON OBJECT and NOTHING ELSE!
                    - Again, confirm the entire response you will provide is parsable by JSON.parse() without any preprocessing
                    - If not try again and ensure these criteria are met this time
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
      {"questions": [{
        "question": String,
        "type": String , //(one of "multiple_choice", "select", "boolean", "text")
        "options": [String] // (only for "multiple_choice" and "select" types)
      }]
      }
    """
end
