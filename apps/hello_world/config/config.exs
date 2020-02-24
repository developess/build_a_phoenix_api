# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

# Configures the endpoint
config :hello_world, HelloWorldWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "RnlUzB0nHEiC6o1Vcu/bCvO0dYJnuxc1IhS484NN1rZ1W2xL5PHEKLLR4Lg+FRfd",
  render_errors: [view: HelloWorldWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: HelloWorld.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
