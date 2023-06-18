# defmodule Openai.Statement do
#   def generate(problem, sector) do
#     with {:ok, response} <-
#            OpenAI.chat_completion(
#              model: "gpt-3.5-turbo",
#              messages: [
#                %{
#                  role: "user",
#                  content:
#                    "Your goal is to rewrite a problem statement to make it more well defined.
#                    The problem statement is for the industry sector #{sector.name}.
#                    "
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
#                  role: "user",
#                  content: "
#                 Now analise the following problem statement shown between the following tripple backticks:
#                     ```#{problem}```.
#                 "
#                }
#              ]
#            ) do
#       [choice | _] = response.choices
#       content = choice["message"]["content"]
#       #IO.inspect(content)
#       {:ok, content}
#     else
#       {:error, error} ->
#         #IO.inspect(error)
#         %{"error" => :timeout}
#     end
#   end

#   def felxible_format() do
#     """
#     The output format MUST be 100% valid HTML it should:

#     - Only return the rewritten problem statemebt html
#     - Do not include any advise or NO EXPLAINATORY messages such as:  "the following is the problem statement".
#     - The output should be a VALID HTML with text not enclosed in any tags.
#     - Valid text tags are P, H1, H2, H3 and H4
#     - Valid list tags are UL and OL
#     - If required you may also use <Code> and <Pre> tags
#     - It May also return assosiated table tags if you have tablur data.

#     """
#   end

#   def format(),
#     do: """

#     The output format MUST be 100% valid HTML it should:

#     - Only return the rewritten problem statemebt html
#     - Do not include any advise or NO EXPLAINATORY messages such as:  "the following is the problem statement".
#     - The output should be a VALID HTML with text not enclosed in any tags.
#     - Valid text tags are P, H1, H2, H3 and H4
#     - Valid list tags are UL and OL
#     - If required you may also use <Code> and <Pre> tags
#     - It May also return assosiated table tags if you have tablur data.

#     Below in the tripple backticks is the format of the output you should return:
#     ```
#       <h1> Problem Statement</h1>

#       //HTML for  problem statement overview - max 2 paragraphs

#       <h2>Who</h2>
#       //HTML for  who is effected statement

#       <h2>What</h2>
#       //HTML for  what are the issues they face

#       <h2>Where</h2>
#       //HTML for Where is this happening

#       <h2>When</h2>
#       //HTML for When is this happening

#       <h2>Why</h2>
#       //HTML for Why is this happening


#       <h1>Potential Solution</h1>
#       //HTML for a potential solution to the problem

#     ```
#     """

#   defp advice(),
#     do: """
#     Below in the triple backticks is advise for a good problem statement to consider:

#     ```
#     A problem statement is a clear explanation of an issue or challenge that sums up what you want to change.
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
