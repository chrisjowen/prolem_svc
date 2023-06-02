defmodule ProblemService.Repo do
  use Ecto.Repo,
    otp_app: :problem_service,
    adapter: Ecto.Adapters.Postgres

  use Scrivener, page_size: 10

  def change(principal, params) when is_atom(principal) and is_map(params) do
    apply(principal, :changeset, [struct(principal), params])
  end

end
