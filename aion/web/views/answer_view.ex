defmodule Aion.AnswerView do
  use Aion.Web, :view

  def render("index.json", %{answers: answers}) do
    %{data: render_many(answers, Aion.AnswerView, "answer.json")}
  end

  def render("show.json", %{answer: answer}) do
    %{data: render_one(answer, Aion.AnswerView, "answer.json")}
  end

  def render("answer.json", %{answer: answer}) do
    %{id: answer.id,
      question_id: answer.question_id,
      content: answer.content}
  end
end
