defmodule Ai.ProblemDiscussionGenerator do
  alias Faker.Commerce
  alias Ai.PromptBuilder
  alias Ai.PromptExecutor

  def execute(statement, sector) do
    {:ok, prompt} =
      PromptBuilder.new()
      |> PromptBuilder.with_type(:json)
      |> PromptBuilder.with_goal(goal())
      |> PromptBuilder.with_hints(hints())
      # |> PromptBuilder.with_examples(examples())
      |> PromptBuilder.with_format(format())
      |> PromptBuilder.with_action(action(statement, sector))
      |> PromptBuilder.build()

    prompt |> PromptExecutor.execute() |> IO.inspect()
  end

  def goal() do
    """
    You are ResearchGTP - an AI that is proficient in understnding a problem statement at determining what areas need further disccusions and research.
    Your goal is to take a problem statement and suggest up to 5 discussions that will be posted to an online forum to be discussed. You will return the response in json format.
    """
  end

  def format() do
    """
    {
      "discussions" : [
        {
          "question": String, //Discussion question to 200 characters
          "body":  String //Discussion body 2-3 paragraphs of html text
          "tags": [String],
        }
      ]
    }
    """
  end

  def hints() do
    """
    Discussion tags things like, but not limited to - technical, legal, compliance, compertition, adoption, commercial, finacial, other
    """
  end


  # def examples() do
  #   """
  #   Prompt:
  #   ```
  #   <h1>Sector: Agro Tech</h1>
  #   <p>A virtual reality therapy application that allows users to virtually confront and cope with their phobias. The app will offer immersive therapy sessions customized to the user's specific phobia and provide a safe and controlled environment for users to face their fears. The app can be used in conjunction with therapy sessions or as a standalone tool.</p>
  #   ```

  #   Response:
  #   ```
  #   ```
  #   """
  # end

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
