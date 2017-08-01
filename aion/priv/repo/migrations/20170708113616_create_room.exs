defmodule Aion.Repo.Migrations.CreateRoom do
  use Ecto.Migration

  def change do
    create table(:rooms) do
      add :name, :string
      add :description, :text

      timestamps()
    end
    create unique_index(:rooms, [:name])

  end
end
