defmodule Aion.Repo.Migrations.CreateRoom do
  use Ecto.Migration

  def change do
    create table(:rooms) do
      add :name, :string
      add :description, :text
      add :owner, references(:users, on_delete: :nothing)

      timestamps()
    end
    create unique_index(:rooms, [:name])
    create index(:rooms, [:owner])

  end
end
