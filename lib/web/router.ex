defmodule ProblemService.Web.Router do
  use ProblemService.Web, :router

  pipeline :api do
    plug(:accepts, ["json"])
  end

  pipeline :auth do
    plug(ProblemService.SecurePipeline)
  end

  scope "/api", ProblemService do
    pipe_through(:api)
    # Unsecured

    get("/image/*path", ImageController, :show)

    resources("/sector", SectorController, only: [:show, :index])

    resources("/link", LinkController, only: [:show, :index])

    resources("/discussion", DiscussionController, only: [:show, :index])

    resources "/problem_suggestion", ProblemSuggestionController, only: [:show, :index]

    resources "/follower", FollowerController, only: [:index]
    resources("/obstacle", ObstacleController, only: [:show, :index])

    resources "/problem", ProblemController, only: [:show, :index] do
      resources("/comment", CommentController, only: [:show, :index])
      resources("/discussion", DiscussionController, only: [:show, :index])
      resources("/obstacle", ObstacleController, only: [:show, :index])
      resources("/link", LinkController, only: [:index, :show])
    end

    resources "/solution", SolutionController, only: [:show, :index] do
      resources("/comment", CommentController, only: [:show, :index])
      resources("/discussion", DiscussionController, only: [:show, :index])
      resources("/link", LinkController, only: [:index, :show])
    end

    resources "/discussion/:discussion_id/answer", AnswerController, only: [:show, :index]

    post("/login", LoginController, :login)
    post("/register", LoginController, :register)
  end

  scope "/api", ProblemService do
    pipe_through([:api, :auth])

    post("/problem/:problem_id/follow", FollowerController, :create)
    post("/problem/:problem_id/unfollow", FollowerController, :unfollow)

    resources("/discussion", DiscussionController, only: [:create, :update, :delete]) do
      resources("/answer", AnswerController, only: [:create, :update, :delete])
    end

    post "/workflow/template", WorkflowController, :problem_template
    post "/workflow/problem_suggestions", WorkflowController, :problem_suggestions
    post "/workflow/problem_resources", WorkflowController, :problem_resources

    post "/ai/problem/precheck", AIProblemController, :precheck

    post "/ai/problem/:problem_id/:type", AIProblemController, :execute
    post "/ai/problem/:type", AIProblemController, :execute

    # post "/ai/problem/statement", ProblemController, :problem_statement
    # post "/ai/problem/links", ProblemController, :links
    # post "/ai/problem/obstacles", ProblemController, :obstacles
    # post "/ai/problem/discussions", ProblemController, :discussions
    # post "/ai/problem/suggestions", ProblemController, :suggestions
    # post "/ai/problem/meta", ProblemController, :meta

    resources "/problem_suggestion", ProblemSuggestionController,
      only: [:create, :update, :delete]

    resources("/obstacle", ObstacleController, only: [:create, :update, :delete])

    resources "/problem", ProblemController, only: [:create, :update, :delete] do
      resources("/comment", CommentController, only: [:create, :update, :delete])
      resources("/discussion", DiscussionController, only: [:create, :update, :delete])
      resources("/obstacle", ObstacleController, only: [:create, :update, :delete])
      resources("/link", LinkController, only: [:create, :update, :delete])
    end

    resources("/product", ProductController, only: [:create, :update, :delete])

    resources "/solution", SolutionController, only: [:create, :update, :delete] do
      resources("/comment", CommentController, only: [:create, :update, :delete])
      resources("/discussion", DiscussionController, only: [:create, :update, :delete])
      resources("/link", LinkController, only: [:create, :update, :delete])
    end

    get("/user/me", UserController, :me)
    get("/user/id", UserController, :id)
    get("/user/:id", UserController, :show)
    post("/user/search", UserController, :search)

    post("/ai/advice/solution/:type", AiSolutionController, :advice)
    post("/ai/advice/text", AiTextController, :advice)
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
      pipe_through([:fetch_session, :protect_from_forgery])

      live_dashboard("/dashboard", metrics: ProblemService.Web.Telemetry)
    end
  end

  # Enables the Swoosh mailbox preview in development.
  #
  # Note that preview only shows emails that were sent by the same
  # node running the Phoenix server.
  if Mix.env() == :dev do
    scope "/dev" do
      pipe_through([:fetch_session, :protect_from_forgery])

      forward("/mailbox", Plug.Swoosh.MailboxPreview)
    end
  end
end
