defmodule ProblemService.ImageController do
  use ProblemService.BaseController


  @image_path "/resources/images/"

  def show(conn, %{"path" => parts }) do

    path = Enum.join(parts, "/")
    image = File.read!(File.cwd!() <> @image_path  <> path)

    # This should be fetched from db, or somehow from the binary.
    mime_type = "image/png"


    conn
    |> put_resp_content_type(mime_type)
    |> send_resp(200, image)
  end


  def create(conn, %{"type" => type, "file" => %Plug.Upload{} = file })  do
    id = Ecto.UUID.generate()
    extension = Path.extname(file.filename)

    path = case type do
      type when type in ["product", "solution", "general"] ->
        path =  "/#{type}/#{id}-#{current_resource(conn).id}#{extension}"
        File.copy!("#{file.path}",  "#{File.cwd!()}#{@image_path}#{path}")
        path
      _ ->
        raise "Invalid type #{type}"
    end


    json(conn, %{"path" => path})

  end


end
