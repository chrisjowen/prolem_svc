defmodule ProblemService.EmailController do
  use ProblemService.Web, :controller

  def send(conn, _) do
    result = ProblemService.UserEmail.welcome() |> ProblemService.Mailer.deliver!()
    json(conn, result)
  end
end
