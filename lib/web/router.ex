defmodule ProblemService.Web.Router do
  use ProblemService.Web, :router

  pipeline :api do
    plug(:accepts, ["json"])
  end

  pipeline :auth do
    plug(ProblemService.SecurePipeline)
  end

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  scope "/oauth", ProblemService do
    pipe_through :browser
    get("/:provider", OAuthController, :request)
    get("/:provider/callback", OAuthController, :callback)
    post("/:provider/callback", OAuthController, :callback)
    delete("/logout", OAuthController, :delete)
  end

  scope "/api", ProblemService do
    pipe_through([:api, :auth])

    get("/user/me", UserController, :me)
    resources("/user/:user_id/profile", UserProfileController, only: [:create, :update, :delete])
    post("/user/search", UserController, :search)

    resources("/soon", ComingSoonController, only: [:create, :update, :delete])

    post("/sector/generate", SectorController, :generate)
    resources("/notification", NotificationController, only: [:show, :index])
    post("/image/:type", ImageController, :create)
    post("/problem/:problem_id/follow", FollowerController, :create)
    post("/problem/:problem_id/unfollow", FollowerController, :unfollow)

    resources("/answer", AnswerController, only: [:create, :update, :delete]) do
      resources("/comment", CommentController, only: [:create, :update, :delete])
    end

    resources("/discussion", DiscussionController, only: [:create, :update, :delete]) do
      resources("/answer", AnswerController, only: [:create, :update, :delete]) do
        resources("/comment", CommentController, only: [:create, :update, :delete])
      end

      resources("/comment", CommentController, only: [:create, :update, :delete])
    end

    post("/workflow/template", WorkflowController, :problem_template)
    post("/workflow/problem_suggestions", WorkflowController, :problem_suggestions)
    post("/workflow/problem_resources", WorkflowController, :problem_resources)
    post("/workflow/problem_obstacles", WorkflowController, :problem_obstacles)
    post("/workflow/problem_stakeholders", WorkflowController, :problem_stakeholders)

    post("/ai/problem/precheck", AIProblemController, :precheck)
    post("/ai/problem/:problem_id/:type", AIProblemController, :execute)
    post("/ai/problem/:type", AIProblemController, :execute)

    resources("/problem_suggestion", ProblemSuggestionController,
      only: [:create, :update, :delete]
    )

    resources("/obstacle", ObstacleController, only: [:create, :update, :delete])
    resources("/notification", NotificationController, only: [:update, :delete])

    resources "/problem", ProblemController, only: [:create, :update, :delete] do
      resources("/page", PageController, only: [:create, :update, :delete])
      resources("/invite", ProblemInviteController, only: [:create, :update, :delete])
      resources("/user", ProblemUserController, only: [:create, :update, :delete])
      resources("/member", ProblemUserController, only: [:create, :update, :delete])
      resources("/comment", CommentController, only: [:create, :update, :delete])
      resources("/discussion", DiscussionController, only: [:create, :update, :delete])
      resources("/obstacle", ObstacleController, only: [:create, :update, :delete])
      resources("/link", LinkController, only: [:create, :update, :delete])
      resources("/stakeholder", StakeholderController, only: [:create, :update, :delete])
    end

    resources("/product", ProductController, only: [:create, :update, :delete])

    resources "/solution", SolutionController, only: [:create, :update, :delete] do
      resources("/comment", CommentController, only: [:create, :update, :delete])
      resources("/discussion", DiscussionController, only: [:create, :update, :delete])
      resources("/link", LinkController, only: [:create, :update, :delete])
    end

    post("/ai/advice/solution/:type", AiSolutionController, :advice)
    post("/ai/advice/text", AiTextController, :advice)
  end

  scope "/api", ProblemService do
    pipe_through(:api)
    # Unsecured
    get("/image/*path", ImageController, :show)

    resources("/soon", ComingSoonController, only: [:index, :show])

    resources("/sector", SectorController, only: [:show, :index]) do
      resources("/problem", ProblemSectorController, only: [:index, :show])
    end

    resources("/link", LinkController, only: [:show, :index])

    resources("/answer", AnswerController, only: [:show, :index]) do
      resources("/comment", CommentController, only: [:show, :index])
    end

    resources("/discussion", DiscussionController, only: [:show, :index]) do
      resources "/answer", AnswerController, only: [:show, :index] do
        resources("/comment", CommentController, only: [:show, :index])
      end

      resources("/comment", CommentController, only: [:show, :index])
    end

    resources("/problem_suggestion", ProblemSuggestionController, only: [:show, :index])
    resources("/follower", FollowerController, only: [:index])
    resources("/obstacle", ObstacleController, only: [:show, :index])
    resources("/user", UserController, only: [:show, :index])
    resources("/membership", ProblemUserController, only: [:show, :index])

    resources "/problem", ProblemController, only: [:show, :index] do
      resources("/sector", ProblemSectorController, only: [:index, :show])
      resources("/invite", ProblemInviteController, only: [:index, :show])
      resources("/feed", ProblemFeedController, only: [:index])
      resources("/user", ProblemUserController, only: [:show, :index])
      resources("/member", ProblemUserController, only: [:show, :index])
      resources("/page", PageController, only: [:show, :index])
      resources("/comment", CommentController, only: [:show, :index])
      resources("/discussion", DiscussionController, only: [:show, :index])
      resources("/obstacle", ObstacleController, only: [:show, :index])
      resources("/link", LinkController, only: [:index, :show])
      resources("/stakeholder", StakeholderController, only: [:index, :show])
    end

    resources "/solution", SolutionController, only: [:show, :index] do
      resources("/comment", CommentController, only: [:show, :index])
      resources("/discussion", DiscussionController, only: [:show, :index])
      resources("/link", LinkController, only: [:index, :show])
    end

    resources("/discussion/:discussion_id/answer", AnswerController, only: [:show, :index])
    post("/login", LoginController, :login)
    post("/register", LoginController, :register)
  end

  # Enables LiveDashboard only for development
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through([:fetch_session, :protect_from_forgery])
      live_dashboard("/dashboard", metrics: ProblemService.Web.Telemetry)
    end
  end

  if Mix.env() == :dev do
    scope "/dev" do
      forward("/mail", Bamboo.SentEmailViewerPlug)
      get("/sendmail", ProblemService.EmailController, :send)
      post("/ai/imagery", ProblemService.AiController, :imagery)
      post("/ai/stakeholder", ProblemService.AiController, :stakeholder)
      post("/ai/sector", ProblemService.AiController, :sector)
      post("/ai/stakeholder_describe", ProblemService.AiController, :stakeholder_describe)
    end
  end
end
