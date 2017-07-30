defmodule Aion.Types do
  @moduledoc """
  This file contains custom type definitions for the whole project
  """
  alias Aion.RoomChannel.UserRecord

  @type answer :: %{content: binary}
  @type question :: %{content: binary, image_name: binary}
  @type room :: %{users: list(user_record), users_count: integer, question: question, answers: list(answer)}
  @type user_record :: %UserRecord{username: binary, score: integer}

  @type process :: {pid, reference}
end
