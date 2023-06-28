defmodule Ai.StakeholderImageGenerator do
  alias Ai.PromptBuilder
  alias Ai.PromptExecutor

  def execute(stakeholder) do
    {:ok, prompt} =
      PromptBuilder.new()
      |> PromptBuilder.with_type(:json)
      |> PromptBuilder.with_goal(goal())
      |> PromptBuilder.with_hints(hints())
      |> PromptBuilder.with_examples(examples())
      |> PromptBuilder.with_format(format())
      |> PromptBuilder.with_action(action(stakeholder))
      |> PromptBuilder.build()

    prompt |> PromptExecutor.execute()
  end

  def goal() do
    """
    You are FictionalGTP - You will be provided with a json structure describing a group of people. Your job is to describe a fictional person associated the group. Return a json response.
    """
  end

  def hints() do
    """
    You aren't supposed to summarize the inforamtion you are supposed to imagine the characteristics of a person that fits into the group described in the json structure.
    Consider the information in the input and detemine what a person in that group would look like. Pay special attention to the races, regions, gender and socioEcenomics
    fields to ensue your description fits the group.
    """
  end

  def format() do
    """
    {
      "name": string,
      "bio": string,
      "race": string,
      "gender": string,
      "age": integer,
      "features": string // i.e. "brown hair, blue eyes, etc."
    }
    """
  end


  def examples() do
    """
     Prompt:
     ```
     {"age_from":null,"age_to":null,"benefits":null,"description":"Individuals who provide assistance and support to visually impaired individuals","education":null,"gender":"ALL","id":307,"img":null,"inserted_at":"2023-06-28T07:37:12","interests":[],"problem":null,"problem_id":222,"problems":["Burdensome task of assisting visually impaired individuals with navigation"],"professions":[],"races":[],"regions":["Global"],"socioEcenomics":[],"type":"Caregivers and Family Members","updated_at":"2023-06-28T07:37:12","user":null,"user_id":1}
     ```

     Response:
     ```
     {
      "name": "John Doe",
      "bio": "John works with visually impared individuals helping them better navigate the world",
      "race": "Chineese",
      "gender": "male",
      "age": 42,
      "features": "thining brown hair, short, overweight, glasses"
    }
    ```
    """
  end


  defp action(stakeholder) do
    """
      The group description is in json in the following folllowing tripple ticks:

      ```
        #{Jason.encode!(stakeholder)}
      ```

    """
  end
end
