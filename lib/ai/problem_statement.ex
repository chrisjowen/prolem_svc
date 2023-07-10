defmodule Ai.ProblemStatementGenerator do
  alias Faker.Commerce
  alias Ai.PromptBuilder
  alias Ai.PromptExecutor

  def execute(overview) do
    {:ok, prompt} =
      PromptBuilder.new()
      |> PromptBuilder.with_type(:html)
      |> PromptBuilder.with_goal(goal())
      |> PromptBuilder.with_hints(hints())
      |> PromptBuilder.with_format(format())
      |> PromptBuilder.with_action(action(overview))
      |> PromptBuilder.build()

    prompt |> PromptExecutor.execute()
  end

  def goal() do
    """
    You are StartupCoachAI: Your goal is to take an idea and rephrase it into a problem statment. You should take the idea and ensure it is phrased as a problem not a solution.
    """
  end

  def format() do
    """
    <h1>Problem Statement</h1>
    //This is the What part - introducing the problem statement with an initial pargrah or two of the biggest problems. This should be a focusing on the problems and not solutions. two to three paragraphs.
    <h2>Who, when and where?</h2>
    //Section listing who would be effected by the problem and if there any time or geographic concerns that are applicable.
    <h3>Examples:</h3>
    //Up to 3 Bullet points of examples of the problem in the real world
    <h2>Why Is It Worth Solving?</h2>
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
        - remove any mention of I or we, this is about the problem not the individual, rephrase according to the stakeholders
        - List the benefits to solving this problem
        ```
    """
  end

  defp action(overview) do
    """
      The problem statement to extend is specified below within the tripple backticks
      ```
       #{overview}
      ```
    """
  end
end
