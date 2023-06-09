defmodule Ai.ProblemStatement do
  alias Faker.Commerce
  alias Ai.PromptBuilder
  alias Ai.PromptExecutor

  def execute(statement, sector) do
    {:ok, prompt} =
      PromptBuilder.new()
      |> PromptBuilder.with_type(:html)
      |> PromptBuilder.with_goal(goal())
      |> PromptBuilder.with_hints(hints())
      |> PromptBuilder.with_format(format())
      |> PromptBuilder.with_action(action(statement, sector))
      |> PromptBuilder.build()

    prompt |> PromptExecutor.execute()
  end

  def goal() do
    """
    Your goal is to generate an expanded HTML problem statement given a small sample and your knowladge.
    """
  end

  def format() do
    """
    <h1>Problem Statement</h1>
    //Section introducing the problem statement with an initial pargrah of the biggest problem pumping up the pain.
    <h2>Why is this a problem?</h2>
    //Section listing  why this is a problem and what is causing it? Are there any specific examples you can provide? If not can you provide a background story explaining this?
    <h2>Who does this effect?</h2>
    //Section listing who does this effect, are there any specific groups or individuals most effected? Can you provide any examples?
    <h2>When & Where Does This Happen?</h2>
    //Section listing when does this happen? Is it a recent thing or has it always been a problem? Where does this happen? Is it a specific location or is it a global problem? Can you provide any examples?
    <h1>Why Is It Worth Solving?</h1>
    //Section listing  the benefits of solving this problem? What are the costs of not solving this problem? Can you provide any examples?
    """
  end

  def hints() do
    """
    Below in the triple backticks is advise for a good problem statement to consider:

    ```
      A problem statement is a clear explanation of an issue or challenge that sums up what you want to change.
      A good problem statement should create awareness and stimulate creative thinking.
      It should not identify a solution or create a bias toward a specific strategy.

      It should identify the:
        - Who: Who is currently experiencing the problem
        - What: What is the problem experienced
        - Why: Why is this a problem
        - When: Has this always been a problem or is it just a recent thing

      When writing:

        - Put the problem in context (what is the current situation and why is it a problem)
        - Describe the precise issue and explain why it matters
        - Explain any financial or other cost of not fixing the problem
        - Support your claims with solid evidence
        - Summarise the problem and the ideal solution
        - Use plain language that everyone can understand
        - List the benefits to solving this problem
        ```
    """
  end

  defp action(statement, sector) do
    """
      The problem statement to extend is specified below within the tripple backticks
      ```
        Sector: #{sector}
        Problem: #{statement}
      ```
    """
  end
end
