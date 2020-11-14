# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :hubbabuddy,
  ecto_repos: [Hubbabuddy.Repo]

# Configures the endpoint
config :hubbabuddy, HubbabuddyWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "6JxZbmgAJnIMBz2x2Rz1RxBtLfSoy7kmby+JKdaTzlAn/35yC2Xrfs8h6FKr2IKg",
  render_errors: [view: HubbabuddyWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Hubbabuddy.PubSub,
  live_view: [signing_salt: "9JIZv0pv"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# OAuth
config :ueberauth, Ueberauth,
  providers: [
    github: {Ueberauth.Strategy.Github, []}
  ]

config :ueberauth, Ueberauth.Strategy.Github.OAuth,
  client_id: System.get_env("GITHUB_CLIENT_ID"),
  client_secret:System.get_env("GITHUB_CLIENT_SECRET")

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
