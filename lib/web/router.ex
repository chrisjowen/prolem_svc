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
    post "/group/search", GroupController, :search
    get "/group/types", GroupTypeController, :list
    get "/group/:id", GroupController, :index
    get "/group/:group_id/chats", GroupChatController, :list


    get "/event_type", EventTypeController, :list
    post "/event/search", EventController, :search
    get "/event/:id", EventController, :index
    get "/tag", TagController, :list
    get "/group/:group_id/media", GroupMediaController, :list
    get "/group/:group_id/media/:id/raw", GroupMediaController, :raw
    post "/event", EventController, :create
    get "/event/:id/banner", EventController, :banner
    get "/user/:id", UserController, :index

  end

  scope "/api", Totem do
    pipe_through([:api, :auth])

    post "/group", GroupController, :create
    post "/group/:group_id/media", GroupMediaController, :create
    get "/group/:group_id/member", GroupMemberController, :list
    post "/group/:group_id/member", GroupMemberController, :create


    post "/share", ShareController, :create


    get "/group_invite/me", GroupInviteController, :mine
    get "/group_invite/:group_id", GroupInviteController, :list
    post "/group_invite/:group_id", GroupInviteController, :create

    get "/notification", NotificationController, :list
    post "/notification/read", NotificationController, :read
    post "/notification/clear", NotificationController, :clear

    get "/follow", UserFollowController, :list
    post "/follow", UserFollowController, :create


    get "/friend_request", FriendRequestController, :list
    post "/friend_request", FriendRequestController, :create


    get "/user/me", UserController, :me
    get "/user/id", UserController, :id
    post "/user/search", UserController, :search

  end


  scope "/auth", Totem do
    pipe_through :api
    post "/login", SessionController, :login
    post "/register", SessionController, :register

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
