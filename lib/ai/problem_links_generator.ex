defmodule Ai.ProblemLinksGenerator do
  alias Faker.Commerce
  alias Ai.PromptBuilder
  alias Ai.PromptExecutor

  def execute(statement, sector) do
    {:ok, prompt} =
      PromptBuilder.new()
      |> PromptBuilder.with_type(:json)
      |> PromptBuilder.with_goal(goal())
      |> PromptBuilder.with_format(format())
      |> PromptBuilder.with_hints(hints())
      |> PromptBuilder.with_action(action(statement, sector))
      |> PromptBuilder.build()

    prompt |> PromptExecutor.execute() |> IO.inspect()
  end

  def goal() do
    """
    "Your goal is to suggest 5-10 url links to resources related to the following problem statement"
    """
  end

  def format() do
    """
    {
      "links" : [
        {
          "name": String,
          "url": String,
          "description": String (max length 100),
          "type": Sting (one of the following: "product", "learning", "other")
        }
      ]
    }
    """
  end

  def hints() do
    """
      1. Check the problem statement for keywords
      2. Check the problem statement for the sector
      3. The types are as follows: "product", "learning", "other"
        - "product" is an existing product that attempts to solve the problem
        - "learning" is a resource that can help the user learn more about the problem
        - "other" is a resource that is related to the problem but does not fit the other two categories
      4. Verify that the links exist and return a 200 response code
    """
  end

  defp action(statement, sector) do
    """
      The problem statement is in HTML format and specified below within the tripple backticks
      ```
        <h1>Sector: #{sector}</h1>
        #{statement}
      ```
    """
  end
end
