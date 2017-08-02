defmodule Aion.RoomView do
  use Aion.Web, :view

  def render("index.json", %{rooms: rooms}) do
    %{data: render_many(rooms, Aion.RoomView, "room.json")}
  end

  def render("show.json", %{room: room}) do
    %{data: render_one(room, Aion.RoomView, "room.json")}
  end

  def render("room.json", %{room: room}) do
    %{id: room.id,
      name: room.name,
      description: room.description}
  end
end
