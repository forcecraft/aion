defmodule Aion.Repo.Migrations.AddNameToUser do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :name, :string, null: false
    end
  end
end
