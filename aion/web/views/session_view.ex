defmodule Aion.SessionView do
  use Aion.Web, :view

  def render("data.json", %{}) do
    %{"token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiYWRtaW4iOnRydWV9.TJVA95OrM7E2cBab30RMHrHDcEfxjoYZgeFONFh7HgQ"}
  end

  def render("error.json", %{}) do
    %{"data": "failed to authorise"}
  end

  def render("login.json", %{jwt: jwt}) do
    %{"token": jwt}
  end
end
