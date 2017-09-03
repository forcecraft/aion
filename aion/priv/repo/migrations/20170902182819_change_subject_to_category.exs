defmodule Aion.Repo.Migrations.ChangeSubjectToCategory do
  use Ecto.Migration

  def change do
    rename table(:subjects), to: table(:categories)
  end
end
