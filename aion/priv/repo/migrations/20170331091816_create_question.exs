defmodule Aion.Repo.Migrations.CreateQuestion do
  use Ecto.Migration

  def change do
    create table(:questions) do
      add :content, :string
      add :image_name, :string
      add :subject_id, references(:subjects, on_delete: :nothing)

      timestamps()
    end
    create index(:questions, [:subject_id])

  end
end
