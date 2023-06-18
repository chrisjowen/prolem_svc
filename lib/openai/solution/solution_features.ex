# defmodule Openai.SuggestSolutionFeatures do
#   alias ProblemService.ProblemRepo
#   alias ProblemService.SolutionRepo

#   def process(%{"problem_id" => problem_id, "solution_id" => solution_id}) do
#     process(ProblemRepo.get(problem_id).overview, SolutionRepo.get(solution_id).description)
#   end

#   def process(problem, solution) do
#     with {:ok, response} <-
#            OpenAI.chat_completion(
#              model: "gpt-3.5-turbo",
#              messages: [
#                %{
#                  role: "user",
#                  content:
#                    "Your job is to suggest up to 10 key features of the solution to a given problem statement"
#                },
#                %{
#                  role: "user",
#                  content: format()
#                },
#                %{
#                  role: "user",
#                  content: hints()
#                },
#                %{
#                  role: "user",
#                  content:
#                    "The problem is stated in HTML in the the tripple backticks that follows: ```#{problem}```"
#                },
#                %{
#                 role: "user",
#                 content:
#                   "The solution overview is stated in HTML in the the tripple backticks that follows: ```#{solution}```"
#               }
#              ]
#            ) do
#       [choice | _] = response.choices
#       Jason.decode(choice["message"]["content"])
#     end
#   end

#   defp format(), do: """
#     The format for the response should be a JSON object with the following format:
#     {
#       "features": [
#         {
#           "name": String, // name of the feature
#           "description": String // description of the feature
#         }]
#     }
#     """

#   defp hints(),
#     do: """
#       When doing your job remember:
#         - The output should be a VALID JSON OBJECT and nothing else.
#         - Check that the response should is parsable by JSON.parse() as is without any preprocessing
#         - ONLY JSON, NO OTHER TEXT
#     """
# end
