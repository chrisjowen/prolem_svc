defmodule ProblemService.UserEmail do
  import Swoosh.Email

  def welcome() do
    new()
    |> to({"Christopher Owen", "chris.j.owen@hotmail.co.uk"})
    # |> to({user.name, user.email})
    |> from({"Support", "mailgun@mail.chrisjowen.net"})
    |> subject("Hello, Avengers!")
    |> html_body("<h1>Hello hi</h1>")
    |> text_body("Hello hi\n")
  end
end
