defmodule ProblemService.Public.ImageController do
  use ProblemService.BaseController

  def show(conn, %{"path" => parts }) do

    path = Enum.join(parts, "/")
    image = File.read!(File.cwd!() <> "/resources/images/" <> path)

    # This should be fetched from db, or somehow from the binary.
    mime_type = "image/png"


    conn
    |> put_resp_content_type(mime_type)
    |> send_resp(200, image)
  end
end
