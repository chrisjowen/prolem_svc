defmodule ProblemService.SectorController do
  use ProblemService.BaseController, [
    schema: ProblemService.Schema.Sector, only: [:show, :index]
  ]

end
