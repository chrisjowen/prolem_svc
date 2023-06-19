defmodule ProblemService.EmailController do
  use ProblemService.Web, :controller

  def send(conn, _) do
    {_, result} = ProblemService.UserEmail.notification(
      %{
        to: "chris.j.owen@hotmail.co.uk",
        user: "James Brown",
        action: "updated problem <p>Some problem</p>",
        href: "http://www.chrisjowen.net",
        link_text: "Some problem",
      }
    )

    |> ProblemService.Mailer.deliver_now()
    json(conn, Util.MapUtil.from_struct(result))
  end
end
