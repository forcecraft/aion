defmodule Aion.CategoryView do
  use Aion.Web, :view

  def render("index.json", %{categories: categories}) do
    %{data: render_many(categories, Aion.CategoryView, "category.json")}
  end

  def render("show.json", %{category: category}) do
    %{data: render_one(category, Aion.CategoryView, "category.json")}
  end

  def render("category.json", %{category: category}) do
    %{id: category.id, name: category.name}
  end

  def render("error.json", %{message: msg}) do
    %{error: msg}
  end
end
