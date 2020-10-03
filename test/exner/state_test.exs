defmodule Exner.StateTest do
  @moduledoc false

  use ExUnit.Case, async: true

  alias Exner.State

  describe "possible_moves/1" do
    test "initial white pawn moves" do
      {:ok, state} = Exner.FEN.starting_board()
      moves = State.possible_moves(state)
      pawn_moves = moves[Exner.Position.parse("b2")]

      assert Enum.count(pawn_moves) == 2
    end

    test "when a move would put you into check" do
      fen = "8/8/8/8/8/8/r1PK4/8 w KQkq - 0 1"
      {:ok, state} = Exner.FEN.parse(fen)
      moves = State.possible_moves(state)
      pawn_moves = moves[Exner.Position.parse("c2")]

      assert Enum.empty?(pawn_moves)
    end
  end

  describe "en passant" do
    test "has no en passant by default" do
      {:ok, state} = Exner.FEN.starting_board()

      refute state.en_passant
    end

    test "no en passant after non-pawn move" do
      {:ok, state} = Exner.FEN.starting_board()
      move = %Exner.Move{from: Exner.Position.parse("a2"), to: Exner.Position.parse("a4")}
      {:ok, state} = State.move(state, move)
      move = %Exner.Move{from: Exner.Position.parse("a1"), to: Exner.Position.parse("a3")}
      {:ok, state} = State.move(state, move)

      refute state.en_passant
    end

    test "no en passant after regular pawn move" do
      {:ok, state} = Exner.FEN.starting_board()
      from = Exner.Position.parse("a2")
      to = Exner.Position.parse("a3")
      move = %Exner.Move{from: from, to: to}
      {:ok, state} = State.move(state, move)

      refute state.en_passant
    end

    test "can en passant after double pawn move" do
      {:ok, state} = Exner.FEN.starting_board()
      from = Exner.Position.parse("a2")
      to = Exner.Position.parse("a4")
      move = %Exner.Move{from: from, to: to}
      {:ok, state} = State.move(state, move)

      assert state.en_passant == Exner.Position.parse("a3")
    end
  end
end
