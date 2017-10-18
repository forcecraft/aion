defmodule Aion.RegistrationView do
  use Aion.Web, :view

  def render("login.json", %{jwt: jwt}) do
    %{"token": jwt}
  end

  def render("error.json", %{}) do
    %{"data": "failed to authorise"}
  end
end
