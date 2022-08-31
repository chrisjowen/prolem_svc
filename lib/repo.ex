defmodule Totem.Repo do
  use Ecto.Repo,
    otp_app: :totem,
    adapter: Ecto.Adapters.Postgres
  use Scrivener, page_size: 10
end
