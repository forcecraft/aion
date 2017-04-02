defmodule Aion.Repo.Migrations.ChangeQuestionToText do
  use Ecto.Migration

  def change do
    alter table(:questions) do
      modify :content, :text
    end
  end
end
