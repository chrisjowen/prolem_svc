defmodule Ai.SectorDescriptionGenerator do
  alias Ai.PromptBuilder
  alias Ai.PromptExecutor

  def execute(sector) do
    {:ok, prompt} =
      PromptBuilder.new()
      |> PromptBuilder.with_type(:html)
      |> PromptBuilder.with_goal(goal())
      |> PromptBuilder.with_hints(hints())
      |> PromptBuilder.with_action(action(sector))
      |> PromptBuilder.build()

    prompt |> PromptExecutor.execute()
  end

  def goal() do
    """
    Your job is to generate an lengthy industry or sector report in HTML format.
    """
  end

  defp hints(),
    do: """
    When generating a report you should consider some of the following:

    1. What is the current state of the sector/industry?
    - What are the overall market size and growth trends?
    - What are the major players in the industry?
    - What is the competitive landscape like?
    - Are there any dominant trends or emerging technologies?

    2. What are the key drivers and challenges?
    - What factors contribute to the growth or decline of the sector/industry?
    - Are there any regulatory or legal issues affecting the industry?
    - What are the main challenges faced by businesses in this sector?

    3. Who are the target customers or clients?
    - What is the target market for the sector/industry?
    - What are the demographics, preferences, and behaviors of the target customers?
    - Are there any specific segments within the market that are more profitable or growing faster?

    4. What are the major products or services?
    - What are the core offerings of businesses in this sector/industry?
    - Are there any unique or innovative products/services?
    - How do the products/services meet the needs of customers?

    5. What are the revenue streams and business models?
    - How do companies generate revenue in this industry?
    - Are there any recurring revenue models or subscription-based services?
    - Are there any major cost drivers or economies of scale?

    6. What are the industry's growth prospects?
    - What are the projected future trends and growth opportunities?
    - Are there any disruptive technologies or business models on the horizon?
    - Are there any barriers to entry or exit that may impact growth?

    7. How is the industry impacted by external factors?
    - Are there any macroeconomic factors affecting the industry?
    - What is the industry's sensitivity to changes in regulations, politics, or global events?
    - Are there any environmental or sustainability considerations?

    8. How is technology influencing the sector/industry?
    - Are there any technological advancements driving change?
    - What role does digitalization or automation play in the industry?
    - Are there any emerging technologies that may disrupt the sector?

    9. What are the risks and opportunities?
    - What are the major risks and challenges faced by businesses in the sector?
    - Are there any untapped market opportunities or underserved segments?
    - Are there any potential partnerships or collaborations that can lead to growth?

    10. What are the long-term trends and predictions?
    - What are the industry experts or analysts forecasting for the future?
    - Are there any demographic, societal, or economic shifts that may impact the sector?
    - How is the sector likely to evolve over the next few years?
    """

  defp action( sector) do
    """
      The problem sector to describe is: "#{sector}"
    """
  end
end
