defmodule Aion.Repo.Migrations.RenameTableSubjectToCategory do
  use Ecto.Migration

  def change do
    rename table(:subjects), to: table(:categories)
  end
end
