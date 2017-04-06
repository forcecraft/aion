defmodule Aion.QuestionView do
  use Aion.Web, :view

  def render("index.json", %{questions: questions}) do
    %{data: render_many(questions, Aion.QuestionView, "question.json")}
  end

  def render("show.json", %{question: question}) do
    %{data: render_one(question, Aion.QuestionView, "question.json")}
  end

  def render("question.json", %{question: question}) do
    %{id: question.id,
      subject_id: question.subject_id,
      content: question.content,
      image_name: question.image_name}
  end
end
