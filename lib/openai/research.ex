defmodule Openai.Research do
  def solution(problem_statement) do
    expansion =
      "Given the problem statement suggest a software based solution, detail the challanges and an overall description of the proposed solution.

      The response should be in valid markdown in the format:

      # Problem Statement
      ${summarized problem}

      # Challenges
        - ${challange list}

      ## Proposed Solution

      ${Description of the solution}

      # Differentators
        - ${differentiators list}

      "
    expand_problem(problem_statement, expansion, false)
  end

  def features(problem_statement) do
    expansion =
      "Given the problem statement suggest a software based solution and the killer features that would differentiate it. Provide response in the format:
      {
            \"solution\": String,
            \"features\": [name, description],
            \"potential_technologies\": [string],
            \"complexity\": percent
      }
      The response should ONLY be valid JSON that can be parsed with JSON.parse()
    "

    expand_problem(problem_statement, expansion)
  end

  def improvements(problem_statement) do
    expansion =
      "Give additional suggestions on what the user could add expand on the problem statement in the format:

      Provide response in the format:
    {
      \"improvements\":  [{
          \"area\": String - area to improve,
          \"improvement\": String (max length 200) - the improvement ,
          \"example\": String (max length 200) - reason for the improvement,
        }
      ]
    }
      The response should ONLY be valid JSON that can be parsed with JSON.parse()
    "

    expand_problem(problem_statement, expansion)
  end

  def similar_products(problem_statement) do
    expansion =
      "Suggest products that address a similar problem to this. Only know products, no need to browse the internet I know you cannot do this. The response should be in the json format
        { \"products\" : [
            {
              \"name\": String,
              \"url\": String,
              \"description\": String (max length 100),
              \"similarity\": Int (1-10),
              \"crunchbaseSlug\": String (optional),
              \"crunchbaseURL\": String (optional),
              \"productHuntUrl\": String (optional),
              \"productHuntId\": String (optional)
            }
          ]
        }
        The response should ONLY be 100% VALID JSON that can be parsed with JSON.parse()
      "

    expand_problem(problem_statement, expansion)
  end

  defp expand_problem(problem_statement, expansion, encode \\ true) do
    with {:ok, response} <-
           OpenAI.chat_completion(
             model: "gpt-3.5-turbo",
             messages: [
               %{
                 role: "system",
                 content:
                   "You job is to help brainstorm ideas for problems that can be solved by software startups."
               },
               %{
                 role: "user",
                 content: "Given the following problem statement: #{problem_statement}
            "
               },
               %{
                 role: "user",
                 content: expansion
               }
             ]
           ) do
      decode_choices(response, encode)
    else
      {:error, error} ->
        IO.inspect(error)
        %{"error" => :timeout}
    end
  end

  defp decode_choices(response, encode) do
    [choice | _] = response.choices
    content = choice["message"]["content"]
    IO.inspect(content)
    case encode do
      true -> content |> Jason.decode!()
      _ -> content
    end
  end
end
