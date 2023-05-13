defmodule ProblemService.SecurePipeline do
  use Guardian.Plug.Pipeline, otp_app: :problem_service

  plug Guardian.Plug.VerifyHeader
  plug Guardian.Plug.EnsureAuthenticated
  plug Guardian.Plug.LoadResource, allow_blank: true
  plug ProblemService.Plug.UserToParams
end
