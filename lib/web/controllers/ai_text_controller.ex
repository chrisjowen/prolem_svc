defmodule ProblemService.AiTextController do
  use ProblemService.BaseController

  def advice(conn, params) do
    with {:ok, result} <- Openai.EditText.generate(params) do
      json(conn, result)
    end
  end
end
