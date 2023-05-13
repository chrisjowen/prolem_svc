defmodule ProblemService.Web.Router do
  use ProblemService.Web, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :auth do
    plug(ProblemService.SecurePipeline)
  end

  scope "/api", ProblemService.Public do
    pipe_through :api
    # Unsecured

    get "/problem", ProblemsController, :list
    get "/problem/:id", ProblemsController, :show
    post "/problem", ProblemsController, :create
    put "/problem/:id", ProblemsController, :update

    post "/problem/submit", ProblemsController, :submit


    get "/problem/:problem_id/product", ProblemProductController, :list
    post "/problem/:problem_id/product/submit", ProblemProductController, :submit
    post "/problem/:problem_id/stakeholder/submit", ProblemStakeholderController, :submit
    get "/problem/:problem_id/stakeholder", ProblemStakeholderController, :list
    get "/problem/:problem_id/solution", ProblemSolutionController, :list
    get "/problem/:problem_id/questionaire", ProblemQuestionaireController, :list



    post "/assistant/improve", AssistantController, :improvements
    post "/assistant/similar", AssistantController, :similar
    post "/assistant/solution", AssistantController, :solution
    post "/assistant/features", AssistantController, :features
    post "/assistant/persona", AssistantController, :persona
    post "/assistant/persona/avatar", AssistantController, :avatar
    post "/assistant/actors", AssistantController, :actors
    post "/assistant/statement", AssistantController, :statement

  end

  scope "/api", ProblemService do
    pipe_through([:api, :auth])
    get "/user/me", UserController, :me
    get "/user/id", UserController, :id
    post "/user/search", UserController, :search

  end


  scope "/auth", ProblemService do
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

      live_dashboard "/dashboard", metrics: ProblemService.Web.Telemetry
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
