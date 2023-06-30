defmodule ProblemScv.Integration.OpenAITest do
  alias ProblemService.StakeholderRepo
  alias ProblemService.ProblemRepo
  use ProblemService.DataCase

  @tag :integration
  test "gmail" do
    # problem = ProblemRepo.get(2)
    # tasks = StakeholderRepo.all_for_problem(problem.id)
    # |> Enum.map(fn stakeholder ->
    #   Task.async( fn  ->
    #     Openai.Questionaire.generate(problem.overview, "TYPE: #{stakeholder.type}, DESCRIPTION: TYPE: #{stakeholder.description}, PROBLEMS: #{Enum.join(stakeholder.problems, ",")}")
    #     |> #IO.inspect
    #   end )
    # end)

    # Enum.each(tasks, fn task ->
    #   Task.await(task, 10 * 60 * 1000)
    # end)

    # problem = ProblemRepo.get(2)
    # stakeholders = StakeholderRepo.all_for_problem(problem.id)

    # ProblemService.Workers.QuestionaireWorker.perform(
    #   %{
    #     problem_id: problem.id,
    #     stakeholder_id: Enum.at(stakeholders, 0).id,
    #     user_id: 1,
    #     identifier: "test"
    #   }
    # )

    # ProblemService.Workers.SectorImageWorker.perform(40)


  end

  # @tag :integration
  # test "checking_completions" do
  #   prompt = "robot thinking pencil drawing "

  #   with {:ok, response} <-
  #          OpenAI.images_generations(
  #            [prompt: prompt, size: "512x512"],
  #            # optional!
  #            %OpenAI.Config{http_options: [recv_timeout: 10 * 60 * 1000]}
  #          ) do
  #     [h | _] = response.data
  #     #IO.inspect(h)
  #   end
  # end
end
