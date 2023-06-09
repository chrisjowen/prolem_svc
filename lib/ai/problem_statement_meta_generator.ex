defmodule Ai.ProblemStatementMetaGenerator do
  alias Faker.Commerce
  alias Ai.PromptBuilder
  alias Ai.PromptExecutor

  def execute(statement, sector) do
    {:ok, prompt} =
      PromptBuilder.new()
      |> PromptBuilder.with_type(:json)
      |> PromptBuilder.with_goal(goal())
      |> PromptBuilder.with_hints(hints())
      |> PromptBuilder.with_examples(examples())
      |> PromptBuilder.with_format(format())
      |> PromptBuilder.with_action(action(statement, sector))
      |> PromptBuilder.build()

    prompt |> PromptExecutor.execute()
  end

  def goal() do
    """
    Your goal is to extract some meta data about a problem statment, the response should be in JSON format.
    """
  end

  def format() do
    """
    {
      "imagery": String,
      "title": String,
      "blurb": String
    }
    """
  end

  def hints() do
    """
      For the following fields, here is some advice on how to extract them:

      - Imagery: Describe what imagery you would expect to be associated with the input.
      - Title: Give the problem statment a title that is no more than 5 words.
      - Blurb: Give a single paragraph high level description of the problem statement.
    """
  end

  def examples() do
    """
      Prompt:
      ```
      The goal is to develop a crop health monitoring system that uses drones and sensors to collect data on crop health. The system should be able to identify potential problems using machine learning algorithms. The aim of this system is to increase crop yields
      ```

      Response:

     ```
     {
      "imagery": "A drone flying over a crop field and capturing images of the crops using a camera attached to it.",
      "title": "Crop Health Monitoring System",
      "blurb": "Develop a crop health monitoring system that uses drones and sensors to collect data on crop health and identify potential problems using machine learning algorithms. The system aims to increase crop yields, reduce the use of harmful pesticides and chemicals, as well as monitor the spread of diseases in crops."
    }
      ```
    """
  end

  defp action(statement, sector) do
    """
      The problem statement to extend is specified below in HTML within the tripple backticks
      ```
        <h1>Sector: #{sector}</h1>
        #{statement}
      ```
    """
  end
end
