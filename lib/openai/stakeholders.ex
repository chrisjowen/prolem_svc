defmodule Openai.Stakeholders do
  def generate(problem) do
    with {:ok, response} <-
           OpenAI.chat_completion(
             model: "gpt-3.5-turbo",
             messages: [
               %{
                 role: "user",
                 content:
                   "Your job is to determine the information of each stakeholder metioned in a problem statement"
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
                   "Determine all stakeholders as mentioned in problem statement in the following tripple backticks ```#{problem}```"
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
      "stakeholders":[
        {
            "type": String (MAX 3 words) , // i.e. software developer or doctors etc.
            "description": String , // description of the type
            "problems": String[], // the problems specific to this stakeholder
            "ageRange":  {  //Optional: if the problem has any age constraints mentioned in problem statement
                "to": Integer,
                "from": Integer
            },
            "regions":  String[] //Optional: if the problem states any geographic constraints mentioned in problem statement,
            "when": String //Optional: Description of when this problem occured - State 'always' if nothing mentioned in problem statement,
            "gender": String //One of [MALE, FEMALE, OTHER, ALL] - use ALL if no gender constraints mentioned in problem statement,
            "otherTraits": String[] //Optional: if the problem states any other traits i.e. lesbian, obese, etc.
            "socioEcenomics": String[] //Optional: if the problem states mentions any socio-economic constraints i.e. poor, rich, etc.
            "race": String //Optional: if the problem states mentions race constraints i.e. white, black, asian etc.
        }
      ]
    }

    """

  defp hints(),
    do: """
      When doing your job remember:

        - The output should be a VALID JSON OBJECT and nothing else.
        - Check that the response should is parsable by JSON.parse() as is without any preprocessing
        - ONLY VALID JSON, NO OTHER TEXT
    """
end
