# defmodule Openai.SolutionOverview do
#   alias ProblemService.Schema.Problem
#   alias ProblemService.Repo

#   def process(%{"problem_id" => problem_id}) do
#     problem = Repo.get(Problem, problem_id)
#     process(problem.overview)
#   end

#   def process(problem) do
#     with {:ok, response} <-
#            OpenAI.chat_completion(
#              model: "gpt-3.5-turbo",
#              messages: [
#                %{
#                  role: "user",
#                  content:
#                    "Your job is to crate and initial solution design for a given problem statement"
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
#                    "Determine the solution design, the problem is stated in HTML in the the tripple backticks that follows: ```#{problem}```"
#                }
#              ]
#            ) do
#       [choice | _] = response.choices
#       {:ok, choice["message"]}
#     end
#   end

#   defp format(),
#     do: """
#     The format for the response should be HTML format with an initial overview section and sections for each item mentioned in the problem statement.

#     Each section section should be 1-2 paragraphs long .
#     The sections should be in the following order:

#       -  Summary
#         -  User Requirements
#         -  Technical Requirements
#         -  System Architecture
#         -  Software Modules and Components
#     """

#   defp hints(),
#     do: """
#     A solution design should include a clear understanding of the following items:

#       -  the user requirements
#       -  the technical requirements
#       -  the system architecture
#       -  the advised oftware modules, libraries or tehcnologies


#     Do the best you can, the problem statment may not be complete and you may need to make assumptions. If you do make assumptions, please state them clearly in the solution design.
#     """
# end
