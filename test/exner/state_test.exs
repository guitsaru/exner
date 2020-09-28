defmodule Exner.StateTest do
  @moduledoc false

  use ExUnit.Case, async: true

  alias Exner.State

  describe "possible_moves/1" do
    test "initial white pawn moves" do
      {:ok, state} = Exner.FEN.starting_board()
      moves = State.possible_moves(state)
      pawn_moves = moves[9]

      assert Enum.count(pawn_moves) == 2
    end

    test "when a move would put you into check" do
      fen = "8/8/8/8/8/8/r1PK4/8 w KQkq - 0 1"
      {:ok, state} = Exner.FEN.parse(fen)
      moves = State.possible_moves(state)
      pawn_moves = moves[11]

      assert Enum.empty?(pawn_moves)
    end
  end
end
