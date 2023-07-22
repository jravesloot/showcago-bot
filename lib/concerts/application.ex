defmodule Concerts.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      Concerts.Repo,
      # Start the Telemetry supervisor
      ConcertsWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Concerts.PubSub},
      # Start the Endpoint (http/https)
      ConcertsWeb.Endpoint,
      # Start a worker by calling: Concerts.Worker.start_link(arg)
      # {Concerts.Worker, arg}
      {Concerts.Bot, bot_key: System.get_env("TELEGRAM_BOT_SECRET")}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Concerts.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    ConcertsWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
