defmodule Ai.StakeholderGenerator do
  alias Ai.PromptBuilder
  alias Ai.PromptExecutor

  def execute(idea, problem) do
    {:ok, prompt} =
      PromptBuilder.new()
      |> PromptBuilder.with_type(:json)
      |> PromptBuilder.with_goal(goal())
      |> PromptBuilder.with_hints(hints())
      # |> PromptBuilder.with_examples(examples())
      |> PromptBuilder.with_format(format())
      |> PromptBuilder.with_action(action(idea, problem))
      |> PromptBuilder.build()

    prompt |> PromptExecutor.execute()
  end

  def goal() do
    """
    Your job is to create a fictitional stakeholders for potential customers of a solution for a provided idea and problem statement and return json results.
    """
  end





  def format() do
    """
    {
      "stakeholders": [
         "type": String,                   //Type of stakeholder (MAX 3 words) i.e. software developer or doctors etc.
         "description": String,            //Description of the type
         "problems": String[],             //The problems specific to this stakeholder
         "age_from": Integer,              //Optional: if the problem has any age constraints mentioned in problem statement
         "age_to": Integer,                //Optional: if the problem has any age constraints mentioned in problem statement
         "regions":  String[],             //Optional: if the problem states any geographic constraints mentioned in problem statement,
         "gender": String,                 //One of [MALE | FEMALE | OTHER | ALL] - use ALL if no gender constraints mentioned in problem statement,
         "professions": String[],          //Optional: if tye profession is something that would be valueable information for the problem
         "education": String,              //Optional: if tye profession is something that would be valueable information for the problem
         "interests": String[],            //Optional: if the problem states any other traits i.e. lesbian, obese, etc.
         "socioEcenomics": String[],       //Optional: if the problem states mentions any socio-economic constraints i.e. poor, rich, etc.
         "races": String[]                 //Optional: if the problem states mentions race constraints i.e. white, black, asian etc.
      ]
    }
    """
  end

  def hints() do
    """
    A user persona is a fictional profile of your ideal customer based on market and audience research.
    In other words, its an imaginary person that embodies the most important characteristics found within your broad audience.
    Just like a real living and breathing customer, a persona should have a demographic and psychographic profile, behavior trends, values, desires,
    pain points, and affiliations. Though the persona is fictional, the profile should be as well rounded as possible.
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

  defp action(idea, problem) do
    """
      The idea is in the folllowing tripple ticks:application

      ```
        #{idea}
      ```

      And the problem statement is in HTML format in the following tripple ticks:

      ```
        #{problem}
      ```

    """
  end
end
