defmodule Aion.Ranking do
  @moduledoc """
  This module provides logic for generating rankings
  """
  import Ecto.Query, only: [from: 2]

  alias Aion.{
    Repo,
    User,
    UserCategoryScore
  }

  @type user_general_score :: %{user_name: String.t(), score: integer}

  @spec general :: list(user_general_score)
  def general do
    Repo.all(
      from(
        q in User,
        join: ucs in UserCategoryScore,
        on: q.id == ucs.user_id,
        group_by: q.name,
        select: %{user_name: q.name, score: sum(ucs.score)}
      )
    )
  end
end
