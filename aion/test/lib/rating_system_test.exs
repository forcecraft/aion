defmodule Aion.RatingSystemTest do
  use Aion.ModelCase
  alias Aion.RatingSystem

  describe "Ranking.loser_delta/2" do
    test "returns decrease value for the loser" do
      winner_rating = 1500
      looser_rating = 1600

      assert RatingSystem.loser_delta(looser_rating, winner_rating) == -20
    end
  end

  describe "Ranking.winner_delta/2" do
    test "returns decrease value for the loser" do
      winner_rating = 1500
      opponents_ratings = [1300, 1450, 1800, 1150]
      expected_result = 8 + 14 + 27 + 4

      assert RatingSystem.winner_delta(winner_rating, opponents_ratings) == expected_result
    end
  end
end
