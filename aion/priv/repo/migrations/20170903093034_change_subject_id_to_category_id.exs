defmodule Aion.Repo.Migrations.ChangeSubjectIdToCategoryId do
  use Ecto.Migration

  def change do
    rename table(:room_categories), :subject_id, to: :category_id
  end
end
