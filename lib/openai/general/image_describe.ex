# defmodule Openai.ImageDescribe do
#   def execute(context) do
#     with {:ok, response} <-
#            OpenAI.chat_completion(
#              model: "gpt-3.5-turbo",
#              messages: [
#                %{
#                  role: "user",
#                  content:
#                    "Your job is take a context HTML document and give a list of up to 5 imagery associated with the document. Be creative suggest images that are not obvious."
#                },
#                %{
#                  role: "user",
#                  content:
#                    "The format returned should be valid JSON as specified in the tripple backticks ```#{format()}```"
#                },
#                %{
#                 role: "user",
#                 content: hints()
#                },
#                %{
#                  role: "user",
#                  content: """
#                   The conext HTML document is shown below:
#                   ```#{context}```
#                  """
#                }
#              ]
#            ) do
#       [choice | _] = response.choices
#       content = choice["message"]["content"]
#       #IO.inspect(content)
#       {:ok, Jason.decode!(String.replace(content, "```", "", global: true))}
#     end
#   end

#   defp format() do
#     """
#       {
#         "imagery": string[]
#       }
#     """
#   end

#   defp hints(),
#   do: """
#     When doing your job remember:

#       - The output should be a VALID JSON OBJECT and NOTHING ELSE!
#       - Again, confirm the ENTIRE response you will provide is parsable by JSON.parse() without any preprocessing
#       - If not try again and ensure these criteria are met this time
#   """
# end
