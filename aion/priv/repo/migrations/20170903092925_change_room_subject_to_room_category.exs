defmodule Aion.Repo.Migrations.ChangeRoomSubjectToRoomCategory do
  use Ecto.Migration

  def change do
      rename table(:room_subjects), to: table(:room_categories)
  end
end
