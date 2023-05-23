defmodule ProblemService.ProductController do
  use ProblemService.BaseController
  alias ProblemService.ProductRepo

  def delete(conn, %{"id" => id}) do
    product = ProductRepo.get(id)
    ProductRepo.delete!(product)
    json(conn, %{ok: id})
  end
end
