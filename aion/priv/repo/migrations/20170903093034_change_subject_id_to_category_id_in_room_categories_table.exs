defmodule Aion.Repo.Migrations.ChangeSubjectIdToCategoryIdInRoomCategoriesTable do
  use Ecto.Migration

  def change do
    rename table(:room_categories), :subject_id, to: :category_id
  end
end
