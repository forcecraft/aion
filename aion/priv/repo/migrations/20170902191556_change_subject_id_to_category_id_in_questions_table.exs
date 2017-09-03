defmodule Aion.Repo.Migrations.ChangeSubjectIdToCategoryIdInQuestionsTable do
  use Ecto.Migration

  def change do
    rename table(:questions), :subject_id, to: :category_id
  end
end
