defmodule Aion.RoomSubjectView do
  use Aion.Web, :view

  def render("index.json", %{room_subjects: room_subjects}) do
    %{data: render_many(room_subjects, Aion.RoomSubjectView, "room_subject.json")}
  end

  def render("show.json", %{room_subject: room_subject}) do
    %{data: render_one(room_subject, Aion.RoomSubjectView, "room_subject.json")}
  end

  def render("room_subject.json", %{room_subject: room_subject}) do
    %{id: room_subject.id,
      room_id: room_subject.room_id,
      subject_id: room_subject.subject_id}
  end
end
