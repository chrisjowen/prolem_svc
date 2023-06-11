defmodule Ai.ProblemResourceGenerator do
  alias Faker.Commerce
  alias Ai.PromptBuilder
  alias Ai.PromptExecutor

  def execute(statement, sector) do
    {:ok, prompt} =
      PromptBuilder.new()
      |> PromptBuilder.with_type(:json)
      |> PromptBuilder.with_goal(goal())
      |> PromptBuilder.with_goal(hints())
      |> PromptBuilder.with_examples(examples())
      |> PromptBuilder.with_format(format())
      |> PromptBuilder.with_action(action(statement, sector))
      |> PromptBuilder.build()

    prompt |> PromptExecutor.execute()
  end

  def goal() do
    """
    You are ResearchGTP - a research AI that is proficient in finding online resources related to a problem statement.
    Your goal is to take a problem statement and return JSON for up to 20 online resources that are relevent to the statement.
    Each resource should be categoriesed into one of the following categories - learning, produduct, market-research or other.
    """
  end

  def hints() do
    """
    When suggesting url's use your knowladge of existing website so ensure that you only suggest valid URL's that link to real existing, live web pages.
    """
  end

  def format() do
    """
    {
      "resources" : [
        {
          "type": String,
          "url": String,
          "text":  String
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
    {"resources" : [{"type": "learning","url": "https://www.pluralsight.com/courses/unity-vr-fundamentals","text":"Unity VR Fundamentals"},{"type": "learning","url": "https://www.udemy.com/course/learn-a-frame-and-get-ready-for-webvr","text":"Learn A-Frame And Get Ready For WebVR"},{"type": "product","url": "https://ameliavirtualcare.com/","text":"Virtual Reality for Mental Health Professionals"},{"type": "product","url": "https://olivebranch.com.sg/vrtherapy/index.html","text":"Virutal Reality for psychological well being."},{"type": "market-research","url": "https://www.statista.com/outlook/amo/ar-vr/worldwide#:~:text=Revenue%20in%20the%20AR%20%26%20VR,US%2411.58bn%20in%202023.","text":"VR Market Size"},{"type": "other","url": "https://www.roadtovr.com/phobos-virtual-reality-therapy-phobia-anxiety-indiegogo/","text":"‘PHOBOS’ is a VR Therapy Platform for Phobias and Anxiety, Now on Indiegogo"}]}
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
