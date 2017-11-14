defmodule Aion.RoomCategoryView do
  use Aion.Web, :view

  def render("index.json", %{room_categories: room_categories}) do
    %{data: render_many(room_categories, Aion.RoomCategoryView, "room_categories.json")}
  end

  def render("show.json", %{room_category: room_category}) do
    %{data: render_one(room_category, Aion.RoomCategoryView, "room_category.json")}
  end

  def render("room_category.json", %{room_category: room_category}) do
    %{
      id: room_category.id,
      room_id: room_category.room_id,
      category_id: room_category.category_id
    }
  end

  def render("error.json", %{message: msg}) do
    %{error: msg}
  end
end
