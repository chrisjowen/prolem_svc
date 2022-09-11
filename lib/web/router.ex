defmodule TotemWeb.Router do
  use TotemWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end


  pipeline :auth do
    plug(Totem.SecurePipeline)
  end


  scope "/api", Totem do
    pipe_through :api
    get "/group", GroupController, :list
    get "/group/types", GroupTypeController, :list
    get "/group/:id", GroupController, :index
    get "/group/:group_id/chats", GroupChatController, :list
    get "/tag", TagController, :list
    get "/group/:group_id/media", GroupMediaController, :list
    get "/group/:group_id/media/:id/raw", GroupMediaController, :raw


  end

  scope "/api", Totem do
    pipe_through([:api, :auth])

    post "/group", GroupController, :create
    post "/group/:group_id/media", GroupMediaController, :create
    get "/group/:group_id/member", GroupMemberController, :list
    post "/group/:group_id/member", GroupMemberController, :create


    get "/group/:group_id/invite", GroupInviteController, :list
    post "/group/:group_id/invite", GroupInviteController, :create

    get "/user/me", UserController, :me
    get "/user/id", UserController, :id
    post "/user/search", UserController, :search

  end


  scope "/auth", Totem do
    pipe_through :api
    post "/login", SessionController, :login

    # TODO: Uberauth may be a bit of a PITA
    get "/:provider", AuthController, :request
    get "/:provider/callback", AuthController, :callback
  end




  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through [:fetch_session, :protect_from_forgery]

      live_dashboard "/dashboard", metrics: TotemWeb.Telemetry
    end
  end

  # Enables the Swoosh mailbox preview in development.
  #
  # Note that preview only shows emails that were sent by the same
  # node running the Phoenix server.
  if Mix.env() == :dev do
    scope "/dev" do
      pipe_through [:fetch_session, :protect_from_forgery]

      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
