defmodule Aion.Router do
  use Aion.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug :fetch_session
    plug :fetch_flash
  end

  pipeline :api_auth do
    plug Guardian.Plug.VerifyHeader, realm: "Bearer"
    plug Guardian.Plug.LoadResource
  end

  scope "/register", Aion do
    pipe_through :api

    post "/", RegistrationController, :create, only: [:new, :create]
  end

  scope "/sessions", Aion do
    pipe_through :api

    post "/", SessionController, :create, only: [:new, :create, :delete]
  end

  scope "/", Aion do
    pipe_through :browser

    get "/", PageController, :index
  end

  scope "/api", Aion do
    pipe_through [:api, :api_auth]

    get "/me", UserController, :get_user_info
    get "/counts", RoomController, :get_counts
    resources "/categories", CategoryController, only: [:index, :show]
    resources "/questions", QuestionController, only: [:index, :show]
    resources "/answers", AnswerController, only: [:index, :show]
    resources "/rooms", RoomController, only: [:index, :show]
    resources "/room_categories", RoomCategoryController, only: [:index, :show]
  end
end
