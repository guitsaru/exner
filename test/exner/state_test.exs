defmodule Exner.StateTest do
  @moduledoc false

  use ExUnit.Case, async: true

  alias Exner.State

  describe "possible_moves/1" do
    test "initial white pawn moves" do
      {:ok, state} = Exner.FEN.starting_board()
      moves = State.possible_moves(state) |> IO.inspect()
      pawn_moves = moves[9]

      assert Enum.count(pawn_moves) == 2
    end
  end
end
