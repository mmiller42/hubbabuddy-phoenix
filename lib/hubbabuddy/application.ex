defmodule Hubbabuddy.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      Hubbabuddy.Repo,
      # Start the Telemetry supervisor
      HubbabuddyWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Hubbabuddy.PubSub},
      # Start the Endpoint (http/https)
      HubbabuddyWeb.Endpoint
      # Start a worker by calling: Hubbabuddy.Worker.start_link(arg)
      # {Hubbabuddy.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Hubbabuddy.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    HubbabuddyWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
