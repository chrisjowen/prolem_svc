defmodule Ai.ProblemSuggestionGenerator do
  alias Faker.Commerce
  alias Ai.PromptBuilder
  alias Ai.PromptExecutor

  def execute(sector) do
    {:ok, prompt} =
      PromptBuilder.new(1)
      |> PromptBuilder.with_type(:json)
      |> PromptBuilder.with_goal(goal())
      |> PromptBuilder.with_hints(hints())
      |> PromptBuilder.with_examples(examples())
      |> PromptBuilder.with_format(format())
      |> PromptBuilder.with_action(action(sector))
      |> PromptBuilder.build()

    prompt |> PromptExecutor.execute()
  end

  def goal() do
    """
    Your goal is to suggest 10 startup problem statments for a given sector, the response should be in JSON format.
    """
  end

  def format() do
    """
    {
      "suggestions"[
        "title": String,
        "blurb": String
      ]
    }
    """
  end

  def hints() do
    """
      1. Be creative with the title, dont just use the sector name.
      2. Dont suggest obvious problems, be creative.
      3. If there are many existing solutions for the problem then dont suggest it.
      4. Think outside of the box, dont just suggest problems that are already being solved.

      For the following fields, here is some advice on how to extract them:

      - title: A title of the suggested problem statement that is no more than 5 words.
      - blurb: A single paragraph high level description of the problem statement.
    """
  end

  def examples() do
    """
     Prompt:
     ```
     The problem sector to suggest problem statements for is: "Virtual reality (VR)"
     ```

     Response:
     ```
     {
      "responses": [
        {
          "title": "Workplace Safety Training",
          "blurb": "Using virtual reality as a therapy to help immersive sessions for user's specific phobia with a safe and controlled environment for confronting their fears"
        },
        {
          "title": "Safe Phobia Therapy,
          "blurb": "Provide a safe environment for employees to learn and practice emergency procedures such as fire drills, earthquake drills, and active shooter drills"
        }
      ]
    }
      ```
    """
  end

  defp action( sector) do
    """
      The problem sector to suggest problem statements for is: "#{sector}"
    """
  end
end
