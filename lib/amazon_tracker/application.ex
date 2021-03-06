defmodule AmazonTracker.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      AmazonTracker.Repo,
      # Start the Telemetry supervisor
      AmazonTrackerWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: AmazonTracker.PubSub},
      {Task.Supervisor, name: AmazonTracker.TaskSupervisor},
      AmazonTracker.Amazon.Tracker,
      # Start the Endpoint (http/https)
      AmazonTrackerWeb.Endpoint
      # Start a worker by calling: AmazonTracker.Worker.start_link(arg)
      # {AmazonTracker.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: AmazonTracker.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    AmazonTrackerWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
