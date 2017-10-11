defmodule Aion.UserView do
  use Aion.Web, :view

   def render("user.json", %{user: user}) do
     %{id: user.id,
       name: user.name,
       email: user.email}
   end
end
