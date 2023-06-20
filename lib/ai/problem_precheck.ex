defmodule Ai.ProblemPrecheck do
  alias Faker.Commerce
  alias Ai.PromptBuilder
  alias Ai.PromptExecutor

  def execute(statement, sector, sectors) do
    {:ok, prompt} =
      PromptBuilder.new()
      |> PromptBuilder.with_type(:json)
      |> PromptBuilder.with_goal(goal())
      |> PromptBuilder.with_hints(hints(sectors))
      |> PromptBuilder.with_format(format())
      |> PromptBuilder.with_examples(examples())
      |> PromptBuilder.with_action(action(statement, sector))
      |> PromptBuilder.build()

    prompt |> PromptExecutor.execute() |> IO.inspect()
  end

  def goal() do
    """
    Your goal is to check a breif problem statement for a given sector and  provide improvement hints in json format.
    """
  end

  def format() do
    """
    {
      "score": "Integer - // percentage how confident you are that the problem statement can be expanded",
      "proposedSector": "String - Name of the sector that is most relevent to the problem statement",
      "hints": [
        {
          "hint": "String: The hint you would give to the user to expand the problem statement"
        }
      ]
    }
    """
  end

  def hints(sectors) do
    """
    The key proposedSector MUST be one of [#{Enum.join(sectors, "|")}]
    """
  end

  def examples() do
    """
        Here are some examples:

        Input:
        ```
        People looking for a fruit in london
        ```

        Output:
        ```
          {
            "score": 30,
            "proposedSector": "E-Commerce",
            "hints": [
              {
                "hint": "What fruit are they looking for?",
              },
              {
                "hint": "Where in London are they looking?"
              }
            ]
          }
        ```

        Input:
        ```
        Some utter nonsense
        ```

        Output:
        ```
          {
            "error": "Not enough informaiton provided"
          }
        ```

        Input:
        ```
        Wearable technology that tracks users movements so family can keep them safe
        ```

        Output:
        ```
          {
            "score": 55,
            "proposedSector": "Wearable Tech",
            "hints": [
              {
                "hint": "Consider the target audience for the wearable technology. Who would use it and why?"
              },
              {
                "hint": "Explain how this is relevent to the E-Commerce sector"
              }
            ]
          }


        ```
        Input:
        ```
        When hiring cars aborad most local help center numbers provided do not have multilingual operators, as such the communication between the customer and help desk is limited. With technology for translation being prevelenet in AI this would likely be a solvable problem. Unfortunatly not all organisations or customers are able to understand the advantages of AI
        ```

        Output:
        ```
        {
          "hints": [
              {
                  "hint": "What other problems do customers face when hiring cars abroad?"
              },
              {
                  "hint": "How can the organisations be educated about the advantages of AI?"
              },
              {
                  "hint": "What other applications can the technology for translation be used for?"
              },
              {
                  "hint": "This seems more relevent to AI that E-Commerce, can you explain why it is relevent to E-Commerce?"
              }
          ],
          "score": 84,
          "proposedSector": "AI"

      }
      ```

    """
    |> String.trim()
  end

  defp action(statement, sector) do
    """
      The problem statement is  is specified below within the tripple backticks
      ```
        #{statement}
      ```
    """
  end
end
