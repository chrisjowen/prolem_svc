# defmodule Openai.Monetization do
#   def generate(problem, solution) do
#     with {:ok, response} <-
#            OpenAI.chat_completion(
#              model: "gpt-3.5-turbo",
#              messages: [
#                %{
#                  role: "user",
#                  content:
#                    "Your goal is to advise someone on how to monetize a solution to a problem. You will evaluate their problem statement, and proposed solution."
#                },
#                %{
#                  role: "user",
#                  content: hints()
#                },
#                %{
#                  role: "user",
#                  content: format()
#                },
#                %{
#                 role: "user",
#                 content: "
#                 Below is the problem statement shown between the following tripple backticks:
#                     ```#{problem}```"
#               },
#               %{
#                 role: "user",
#                 content: "
#                 Below is the proposed solution in the following tripple backticks:
#                     ```#{solution}```"
#               },
#               %{
#                 role: "user",
#                 content: "Using the format specified, provide a response that monetizes the solution."
#               },
#              ]
#            ) do
#       [choice | _] = response.choices
#       content = choice["message"]["content"]
#       {:ok, Jason.decode!(content)}
#     else
#       {:error, error} ->
#         # #IO.inspect(error)
#         %{"error" => :timeout}
#     end
#   end

#   defp format(),
#     do: """
#       {
#         "monetization": [
#           {
#             "type": String, //i.e. subscription, affiliate, cross sell etc...
#             "description": String,
#             "links": [ //links to the monetization options
#               {
#                 "url": String,
#                 "description": String
#               }
#             ]
#           }
#         ]
#       }
#     """


#     defp hints(),
#     do: """
#       When doing your job remember:

#         - Dont suggest advertising as a monetization option unless the solution is specifically about adtech
#         - Suggest at least 3 monetization options
#         - The output should be a VALID JSON OBJECT and nothing else.
#         - Check that the response should is parsable by JSON.parse() as is without any preprocessing
#         - ONLY JSON, NO OTHER TEXT
#     """
# end
