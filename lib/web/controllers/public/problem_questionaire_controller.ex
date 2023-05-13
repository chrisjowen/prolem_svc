defmodule ProblemService.Public.ProblemQuestionaireController do
  use ProblemService.BaseController
  alias ProblemService.QuestionaireRepo
  alias ProblemService.ProblemRepo


  def list(conn, %{"problem_id" => problem_id}) do
      json(conn, QuestionaireRepo.all_for_problem(problem_id, [:stakeholder])  |> IO.inspect)
  end

end
