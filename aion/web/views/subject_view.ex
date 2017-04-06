defmodule Aion.SubjectView do
  use Aion.Web, :view

  def render("index.json", %{subjects: subjects}) do
    %{data: render_many(subjects, Aion.SubjectView, "subject.json")}
  end

  def render("show.json", %{subject: subject}) do
    %{data: render_one(subject, Aion.SubjectView, "subject.json")}
  end

  def render("subject.json", %{subject: subject}) do
    %{id: subject.id,
      name: subject.name}
  end
end
