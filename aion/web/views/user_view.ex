defmodule Aion.UserView do
  use Aion.Web, :view

  def render("user.json", %{user: user}) do
    if user != nil do
      %{id: user.id,
      name: user.name,
      email: user.email}
    else
      %{}
    end
  end

  def render("error.json", %{message: msg}) do
    %{"error": msg}
  end
end
