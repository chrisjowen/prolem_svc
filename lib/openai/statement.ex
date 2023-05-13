defmodule Openai.Statement do
  def generate(problem) do
    with {:ok, response} <-
           OpenAI.chat_completion(
             model: "gpt-3.5-turbo",
             messages: [
               %{
                 role: "user",
                 content:
                   "Your goal is to rewrite a problem statement to make it more well defined"
               },
               %{
                 role: "user",
                 content: advice()
               },
               %{
                 role: "user",
                 content:
                   "Use the format shown between the following tripple backticks ```#{format()}```"
               },
               %{
                 role: "user",
                 content: "
                Now analise the following problem statement shown between the following tripple backticks:
                    ```#{problem}```.
                "
               }
             ]
           ) do
      [choice | _] = response.choices
      content = choice["message"]["content"]
      IO.inspect(content)
      {:ok, content}
    else
      {:error, error} ->
        IO.inspect(error)
        %{"error" => :timeout}
    end
  end

  def format(),
    do: """
      <h1> Problem Statement</h1>
      {problem statement overview - max 2 paragraphs}

      <h2>Who</h2>
      {who is effected statement}

      <h2>What</h2>
      {what are the issues they face}

      <h2>Where</h2>
      {Where is this happening}

      <h2>When</h2>
      {When is this happening}

      <h2>Why</h2>
      {Why is this happening}
    """

  defp advice(),
    do: """
    Below in the triple backticks is advise for a good problem statement to consider:

    ```
    A problem statement is a short, clear explanation of an issue or challenge that sums up what you want to change.
    A good problem statement should create awareness and stimulate creative thinking.
    It should not identify a solution or create a bias toward a specific strategy.

    It should identify the:
      - Who: Who is currently experiencing the problem
      - What: What is the problem experienced
      - Why: Why is this a problem
      - When: Has this always been a problem or is it just a recent thing

    ```
    """
end
