defmodule ProblemService.Experts.ExpertFinderClient do
  use ProblemService.DataCase
  alias ProblemService.Clients.Experts.ExpertFinderClient


   @tag :ai
  test "Can fetch  profiles " do
    OpenAI.embeddings(
      model: "gpt-3.5-turbo",
      messages: generate_messages(prompt),
      temperature: prompt.temperature
    )
  end

end
