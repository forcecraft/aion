defmodule Aion.RegistrationView do
  use Aion.Web, :view

  def render("show.json", %{user: user}) do
    render("user.json", %{user: user})
  end

  def render("user.json", %{user: user}) do
    %{id: user.id,
      name: user.name,
      email: user.email}
  end

  def render("error.json", %{}) do
    %{"data": "failed to authorise"}
  end
end
