defmodule Aion.Ranking do
  @moduledoc """
  This module provides logic for generating ranking data
  """
  import Ecto.Query, only: [from: 2]
  alias Aion.{
    Repo,
    User,
    Category,
    UserCategoryScore
  }

  @type category_score_t :: %{category_id: integer, category_name: String.t, scores: (list user_score_t)}
  @type user_score_t :: %{user_name: String.t, score: integer}
  @type raw_data_t :: %{category_id: integer, category_name: String.t, user_name: String.t, score: integer}

  @spec data :: list category_score_t
  def data do
    query_data()
      |> Enum.group_by(&%{category_id: &1.category_id, category_name: &1.category_name},
                       &%{user_name: &1.user_name, score: &1.score})
      |> Map.to_list()
      |> Enum.map(&Map.put(elem(&1, 0), :scores, elem(&1, 1)))
  end

  @spec query_data :: list raw_data_t
  def query_data do
    Repo.all(
      from q in User,
      join: ucs in UserCategoryScore, on: q.id == ucs.user_id,
      join: c in Category, on: c.id == ucs.category_id,
      select: %{category_id: c.id, category_name: c.name, user_name: q.name, score: ucs.score}
    )
  end
end
