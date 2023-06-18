alias ProblemService.UserEmail
alias ProblemService.Mailer
mail = ProblemService.UserEmail.welcome() |> ProblemService.Mailer.deliver!
Mailer.deliver!(mail) |> IO.inspect()
