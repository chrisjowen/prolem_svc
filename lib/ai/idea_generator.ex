defmodule Ai.IdeaGenerator do
  alias Ai.PromptBuilder
  alias Ai.PromptExecutor

  def execute(sectors, sector) do
    {:ok, prompt} =
      PromptBuilder.new(1)
      |> PromptBuilder.with_type(:json)
      |> PromptBuilder.with_goal(goal())
      |> PromptBuilder.with_hints(hints(sectors))
      # |> PromptBuilder.with_examples(examples())
      |> PromptBuilder.with_format(format())
      |> PromptBuilder.with_action(action(sector))
      |> PromptBuilder.build()

    prompt |> PromptExecutor.execute()
  end

  def goal() do
    """
    Your goal is to suggest up to 10 startup ideas for a given sector, the response should be in JSON format.
    """
  end


  def format() do
    """
    {
      "suggestions"[
        "title": String,
        "description": String,
        "tags": String[],
        "features": String[],
        "complexity": Integer,
        "skills": String[],
        "estimated_timescale": Integer,
        "sectors": String[],
        "imagery": String
      ]
    }
    """
  end

  def hints(sectors) do
    """
      1. Be creative with the title, dont just use the sector name.
      2. Dont suggest obvious idea, be creative.
      3. If there are many existing solutions for the idea then dont suggest it.
      4. Think outside of the box, dont just suggest idea that are already being solved.

      For the following fields, here is some advice on how to extract them:

      - title: A title of the suggested problem statement that is no more than 5 words.
      - description: Two paragraphs explaining the idea
      - tags: A list of tags that describe the idea
      - features: A list of features that the idea requires
      - complexity: A percentage of complexity to build the idea
      - estimated_timescale: estimated time to launch the intial version of the idea in months
      - skills: A list of skills required to build the idea
      - sectors: A list of sectors that the idea is related, include the sector that the idea is for but also any related sectors from the following list:
      - imagery: A description of the imagery that represents the idea

      Sectors

      ```
        #{Enum.join(sectors, ",")}
      ```

    """
  end

  def examples() do
    """
     Prompt:
     ```
     The sector to suggest ideas for is: "Virtual reality (VR)"
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

  defp action(sector) do
    """
      The sector to suggest ideas for is: "#{sector}"
    """
  end
end
