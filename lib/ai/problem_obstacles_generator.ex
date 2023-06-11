defmodule Ai.ProblemObstaclesGenerator do
  alias Faker.Commerce
  alias Ai.PromptBuilder
  alias Ai.PromptExecutor

  def execute(statement, sector) do
    {:ok, prompt} =
      PromptBuilder.new()
      |> PromptBuilder.with_type(:json)
      |> PromptBuilder.with_goal(goal())
      |> PromptBuilder.with_examples(examples())
      |> PromptBuilder.with_format(format())
      |> PromptBuilder.with_action(action(statement, sector))
      |> PromptBuilder.build()

    prompt |> PromptExecutor.execute() |> IO.inspect()
  end

  def goal() do
    """
    You are ResearchGTP - a research AI that is proficient in determining obstacles to overvome in solving problems.
    Your goal is to take a problem statement and suggest up to 5 obstacles to solving the problem, these can things like, but not limited to - technical, legal, compliance, compertition, adoption, commercial, finacial, other.
    Each obstacle should be returned in the form of JSON and you should attempt to give  5 questions and a solution hints to overcoming the obstacles.
    """
  end

  def format() do
    """
    {
      "obstacles" : [
        {
          "obstacle": String,
          "types": [String],
          "solutionsHint":  String,
          "questions": [String]
        }
      ]
    }
    """
  end

  def examples() do
    """
    Prompt:
    ```
    <h1>Sector: VR</h1>
    <p>A virtual reality therapy application that allows users to virtually confront and cope with their phobias. The app will offer immersive therapy sessions customized to the user's specific phobia and provide a safe and controlled environment for users to face their fears. The app can be used in conjunction with therapy sessions or as a standalone tool.</p>
    ```

    Response:
    ```
    {"obstacles": [{"obstacle": "Virtual reality sessions may be traumatic for the users","types": ["Technical", "Psycalogical", "User Centric"],"questions": ["What are the best practices for designing a therapeutic VR experience?","Is there any research on VR and trauma?", "How can we gaugue traumatic experiences?", "Are there any mental health professionals who could be consulted during the development process?"],"solutionHint": "Engaging professionals in mental health during the development process could help ensure appropriate therapeutic design. Initial trials with users could also be important in refining the experience."},{"obstacle": "What are the regulatory implications for the development and use of a virtual reality therapy application?","types": ["Legal"],"questions": ["What are legalaties around the use of VR in therapy?","How can we ensure compliance?"],"solutionHint": "Engage legal professionals and experts in medical device or healthcare regulations to guide the development and application of the product."},{"obstacle": "How will this VR therapy app be received in the market in terms of competition?","types": ["Commercial"],"questions": ["What are the existing VR therapy apps in the market?","What would be the unique selling propositions of a solution?"],"solutionHint": "Conducting a market analysis to understand the competition and potential unique selling propositions of your product could be beneficial."},{"obstacle": "How can the app ensure user privacy and data protection?","types": ["Technical","Legal"],"questions": ["What are legalaties around the use of VR in therapy?","What are the best practices for data protection in the healthcare sector?"],"solutionHint": "Integrating robust data protection measures and ensuring compliance with international data protection standards would be crucial."},{"obstacle": "Will the app be affordable and accessible to the users it's intended for?","types": ["Commercial"],"questions": ["What price point would be appropriate for the app?","Are there any subsidies or insurance coverage that could be leveraged?"],"solutionHint": "Consideration should be given to the pricing strategy, and possible insurance coverage or subsidies for the app."}]}
    ```
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
