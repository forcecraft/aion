defmodule Aion.Repo.Migrations.CreateRoomSubject do
  use Ecto.Migration

  def change do
    create table(:room_subjects) do
      add :room_id, references(:rooms, on_delete: :delete_all)
      add :subject_id, references(:subjects, on_delete: :delete_all)

      timestamps()
    end
    create index(:room_subjects, [:room_id])
    create index(:room_subjects, [:subject_id])

  end
end
