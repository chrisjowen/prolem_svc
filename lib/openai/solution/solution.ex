defmodule Openai.Solution do
  def generate(problem) do
    with {:ok, response} <-
           OpenAI.chat_completion(
             model: "gpt-3.5-turbo",
             messages: [
               %{
                 role: "user",
                 content:
                   "Your job is to suggest a software based solution to a problem statement"
               },
               %{
                 role: "user",
                 content: format()
               },
               %{
                 role: "user",
                 content: hints()
               },
               %{
                 role: "user",
                 content:
                   "Determine the full solution to the problem statement in the following tripple backticks ```#{problem}```"
               }
             ]
           ) do
      [choice | _] = response.choices
      content = choice["message"]["content"]
      IO.inspect(content)
      {:ok, Jason.decode!(content)}
    else
      {:error, error} ->
        IO.inspect(error)
        {:error, error}
    end
  end

  defp format(),
    do: """
    The format for the response is defined in following format
    {
      "solution":
        {
            "description": String, // HTML FORMAT - description of the solution (5 paragraphs)
            "keyFeatures": String[], // up to 10 key features of the solution
            "estimatedCost": String, // estimated cost of the solution in USD
            "estimatedTimescale": String, // estimated timescale to create
            "estimatedTeamSize": Int, // estimated teamsise to create the product
            "technologies": String[], // technologies used to create the solution
            "expertise": String[] // expertise or skills needed to create the solution
        }
    }
    """

  defp hints(),
    do: """
      When doing your job remember:

        - The output should be a VALID JSON OBJECT and nothing else.
        - Check that the response should is parsable by JSON.parse() as is without any preprocessing
        - ONLY VALID JSON, NO OTHER TEXT
        - The json should be as compact as possible not return new line breaks i.e. \n in any unquoted part of the json
    """
end
