# defmodule Openai.Advice do
#   def generate(problem) do
#     with {:ok, response} <-
#            OpenAI.chat_completion(
#              model: "gpt-3.5-turbo",
#              messages: [
#                %{
#                  role: "user",
#                  content:
#                    "Your goal is to advise someone on how to write a well defined problem statement. You will evaluate their problem statement and give tips on what to change. "
#                },
#                %{
#                  role: "user",
#                  content: advice()
#                },
#                %{
#                  role: "user",
#                  content: format()
#                },
#                %{
#                 role: "user",
#                 content: "
#                 Now analise the following problem statement shown between the following tripple backticks:
#                     ```#{problem}```.

#                 You expected response format you should provide is between the following tripple backticks:
#                     ```#{format()}```

#                 When performing this task

#                     - The output should be a VALID JSON OBJECT and NOTHING ELSE!
#                     - Double check that you have followed the advise for best practices
#                     - Again, confirm the entire response you will provide is parsable by JSON.parse() without any preprocessing
#                     - If not try again and ensure these criteria are met this time
#                 "
#               },
#              ]
#            ) do
#       [choice | _] = response.choices
#       content = choice["message"]["content"]
#       content |> Jason.decode!()
#     else
#       {:error, error} ->
#         # #IO.inspect(error)
#         %{"error" => :timeout}
#     end
#   end

#   defp format(),
#     do: """
#       {
#         "rating": Integer (percentage out of 100),
#         "advise": String (max 4 paragraphs),
#       }
#     """



#   defp advice(),
#     do: """
#     Below in the triple backticks is advise for a good problem statement to consider:

#     ```
#     A problem statement is a short, clear explanation of an issue or challenge that sums up what you want to change.
#     It helps you, team members, and other stakeholders to focus on the problem, why it’s important, and who it impacts.

#     A good problem statement should create awareness and stimulate creative thinking.
#     It should not identify a solution or create a bias toward a specific strategy.

#     It should identify the:
#       - Who: Who is currently experiencing the problem
#       - What: What is the problem experienced
#       - Why: Why is this a problem
#       - When: Has this always been a problem or is it just a recent thing

#     ```
#     """
# end
