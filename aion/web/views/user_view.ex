defmodule Aion.UserView do
  use Aion.Web, :view

  def render("user.json", %{user: nil}), do: %{}
  def render("user.json", %{user: user}), do: Map.take(user, [:id, :name, :email])

  def render("error.json", %{message: msg}) do
    %{"error": msg}
  end
end
