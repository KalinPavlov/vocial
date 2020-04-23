defmodule VocialWeb.Router do
  use VocialWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug VocialWeb.VerifyApiKey
  end

  scope "/", VocialWeb do
    pipe_through :browser

    get "/", PageController, :index
    get "/history", PageController, :history
    resources "/polls", PollController, only: [:index, :new, :create, :show]
    resources "/users", UserController, only: [:new, :show, :create]
    post "/users/:id/generate_api_key", UserController, :generate_api_key
    resources "/sessions", SessionController, only: [:new, :create, :delete]
    get "/options/:id/vote", PollController, :vote
  end

  scope "/auth", VocialWeb do
    pipe_through :browser

    get "/:provider", SessionController, :request
    get "/:provider/callback", SessionController, :callback
  end

  scope "/api", VocialWeb do
    pipe_through :api

    resources "/polls", Api.PollController, only: [:index, :show]
  end
end
