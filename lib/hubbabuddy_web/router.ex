defmodule HubbabuddyWeb.Router do
  use HubbabuddyWeb, :router

  pipeline :browser do
    plug Ueberauth
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", HubbabuddyWeb do
    pipe_through :browser

    get "/", PageController, :index
    get "/send_slack", PageController, :send_slack
  end

  scope "/auth", HubbabuddyWeb do
    pipe_through :browser

    get "/", AuthController, :index
    get "/logout", AuthController, :delete
    get "/:provider", AuthController, :request
    get "/:provider/callback", AuthController, :callback
  end

  resources "/users", Hubbabuddy.UserController

  # Other scopes may use custom stacks.
  # scope "/api", HubbabuddyWeb do
  #   pipe_through :api
  # end

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
      pipe_through :browser
      live_dashboard "/dashboard", metrics: HubbabuddyWeb.Telemetry
    end
  end
end
