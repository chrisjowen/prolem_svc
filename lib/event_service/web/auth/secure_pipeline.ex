defmodule EventService.SecurePipeline do
  use Guardian.Plug.Pipeline, otp_app: :event_service

  plug Guardian.Plug.VerifyHeader
  plug Guardian.Plug.EnsureAuthenticated
  plug Guardian.Plug.LoadResource, allow_blank: true
end
