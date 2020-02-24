defmodule HelloWorldWeb.Router do
  use HelloWorldWeb, :router

  pipeline :api do
    plug CORSPlug, origin: "http://localhost:1234"
    plug :accepts, ["json"]
  end

  scope "/api", HelloWorldWeb do
    pipe_through :api

    get "/test", CountryController, :test

    # Part 1:
    # Add new REST API routes here
    get "/countries", CountryController, :index
    get "/countries/:name", CountryController, :show
  end
end
