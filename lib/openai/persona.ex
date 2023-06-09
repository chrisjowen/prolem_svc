defmodule Openai.Persona do
  def generate(breif) do
    with {:ok, response} <-
           OpenAI.chat_completion(
             model: "gpt-3.5-turbo",
             messages: [
               %{
                 role: "user",
                 content: "Your job is to create a fictitional personas based on a provided breif"
               },
               %{
                 role: "user",
                 content:
                   "A user persona is a fictional profile of your ideal customer based on market and audience research. In other words, its an imaginary person that embodies the most important characteristics found within your broad audience. Just like a real living and breathing customer, a persona should have a demographic and psychographic profile, behavior trends, values, desires, pain points, and affiliations. Though the persona is fictional, the profile should be as well rounded as possible."
               },
               %{
                 role: "user",
                 content: hints()
               },
               %{
                 role: "user",
                 content: format()
               },
               %{
                 role: "user",
                 content:
                   "Create the persona as descirbed based on the JSON brief in the tripple backticks ```#{Jason.encode!(breif)}```"
               }
             ]
           ) do
      [choice | _] = response.choices
      content = choice["message"]["content"]
      content |> Jason.decode!()
    else
      {:error, error} ->
        #IO.inspect(error)
        %{"error" => :timeout}
    end
  end

  defp format(),
    do: """
    The format for the response is defined in following format
    {
          "name": String,
          "bio": String,
          "ethnicity": String,
          "countryOfBirth": String,
          "painPoints": String,
          "age" : Int,
          "email" : String,
          "gender": String,
          "descriptionOfAppearance": String
      }

    """

  defp hints(),
    do: """
      When doing your job remember:

        - The output should be a VALID JSON OBJECT and nothing else.
        - Use varying profiles that are not too similar
        - Double check that the persona meets the critreia specified.
        - Check that the response should is parsable by JSON.parse() as is without any preprocessing
        - ONLY JSON, NO OTHER TEXT
    """
end
