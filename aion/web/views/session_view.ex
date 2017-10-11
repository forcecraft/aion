defmodule Aion.SessionView do
  use Aion.Web, :view

  def render("error.json", %{}) do
    %{"data": "failed to authorise"}
  end

  def render("login.json", %{jwt: jwt}) do
    %{"token": jwt}
  end
end
