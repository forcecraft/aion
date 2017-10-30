defmodule Aion.RoomView do
  use Aion.Web, :view

  def render("index.json", %{rooms: rooms}) do
    %{data: render_many(rooms, Aion.RoomView, "room.json")}
  end

  def render("index_with_counts.json", %{rooms: rooms}) do
    %{data: render_many(rooms, Aion.RoomView, "room_with_counts.json")}
  end

  def render("show.json", %{room: room}) do
    %{data: render_one(room, Aion.RoomView, "room.json")}
  end

  def render("room.json", %{room: room}) do
    %{id: room.id,
      name: room.name,
      description: room.description}
  end

  def render("room_with_counts.json", %{room: room}) do
    %{id: room.id,
      name: room.name,
      description: room.description,
      player_count: room.player_count,
    }
  end

  def render("error.json", %{message: msg}) do
    %{"error": msg}
  end
end
