# defmodule Openai.SuggestSectorIdeas
# do

#   def execute(name) do
#     with {:ok, response} <-
#            OpenAI.chat_completion(
#              model: "gpt-3.5-turbo",
#              messages: [
#                %{
#                  role: "user",
#                  content: """
#                    Your job is to generate an list of startup ideas for a given sector. "
#                    """
#                },
#                %{
#                  role: "user",
#                  content: "The format returned should be valid JSON as specified in the tripple backticks ```#{format()}```"
#                },
#                %{
#                 role: "user",
#                 content: hints()
#               },
#                %{
#                  role: "user",
#                  content:
#                    "The sector to suggest startup ideas for is is: #{name}."
#                }
#              ]
#            ) do
#       [choice | _] = response.choices
#       content = String.replace(choice["message"]["content"], "```", "", global: true)
#       Jason.decode(content)
#     end
#   end

#   defp format() do
#     """
#       {
#         "ideas": [{
#           "name": String //idea name i.e. rideshare applicaiton ,
#           "description": String //idea description 3-4 paragraphs HTML format
#         }]
#       }
#     """
#   end

#   defp hints(),
#   do: """
#     When doing your job remember:

#       - Try to be original dont suggest ideas that are obvious of have high compertition
#       - The output should be a VALID JSON OBJECT and NOTHING ELSE!
#       - Remove any triple backticks from the output, ONLY JSON should be returned
#       - Confirm the ENTIRE response you will provide is parsable by JSON.parse() without any preprocessing
#       - If not try again and ensure these criteria are met this time
#   """
# end
