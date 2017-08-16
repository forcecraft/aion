defmodule Aion.Router do
  use Aion.Web, :router
  use Addict.RoutesHelper

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/" do
    addict :routes
  end

  scope "/", Aion do
    pipe_through :browser # Use the default browser stack
    get "/", PageController, :index
  end

  scope "/api", Aion do
    pipe_through :api

    get "/me", UserController, :get_user_info
    resources "/subjects", SubjectController, except: [:new, :edit]
    resources "/questions", QuestionController, except: [:new, :edit]
    resources "/answers", AnswerController, except: [:new, :edit]
    resources "/rooms", RoomController, except: [:new, :edit]
    resources "/room_subjects", RoomSubjectController, except: [:new, :edit]
  end
end
