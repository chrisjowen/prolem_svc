defmodule ProblemService.UserEmail do
  use Bamboo.Phoenix, view: ProblemService.EmailView
  alias ProblemService.Schema

  def welcome() do
    new_email(
      to: "chris.j.owen@hotmail.co.uk",
      from: "support@mail.chrisjowen.net"
    )
    |> put_layout({ProblemService.LayoutView, :email})
    |> assign(:dog, "rat girl")
    # Pass atom to render html AND plain text templates
    |> render(:email)
  end

  def notification(%Schema.Notification{} = notification) do
    new_email(
      subject:
        "#{notification.by.name} #{notification.by.last_name} #{notification.action} #{notification.type}",
      to: notification.to.email,
      from: "support@mail.chrisjowen.net"
    )
    |> put_layout({ProblemService.LayoutView, :email})
    |> assign(:notification, notification)
    |> assign(:base_url,  System.get_env("UI_BASE_URL") ||  "http://127.0.0.1:5173")
    |> render(:notification)
  end
end
