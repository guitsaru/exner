defmodule Exner.FENTest do
  use ExUnit.Case, async: true

  alias Exner.{FEN, Position}

  describe "parse/1" do
    test "with an invalid FEN" do
      assert {:error, _} = FEN.parse("Z")
    end

    test "with starting board FEN" do
      fen = "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1"

      assert {:ok, %_{board: board}} = FEN.parse(fen)
      assert Exner.Board.at(board, Position.parse("d1")).color == :white
      assert Exner.Board.at(board, Position.parse("d1")).role == :queen
      assert Exner.Board.at(board, Position.parse("d8")).color == :black
      assert Exner.Board.at(board, Position.parse("d8")).role == :queen
    end

    test "with another board FEN" do
      fen = "rnbqkbnr/pppppppp/8/8/8/P7/1PPPPPPP/RNBQKBNR w KQkq - 0 1"

      assert {:ok, %_{board: board}} = FEN.parse(fen)
      assert Exner.Board.at(board, Position.parse("a3")).color == :white
      assert Exner.Board.at(board, Position.parse("a3")).role == :pawn
    end

    test "with en passant" do
      fen = "rnbqkbnr/pppppppp/8/8/4P3/8/PPPP1PPP/RNBQKBNR b KQkq e3 0 1"

      assert {:ok, state} = FEN.parse(fen)
      assert state.en_passant == Position.parse("e3")
    end

    test "with all castling available" do
      fen = "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1"

      assert {:ok, state} = FEN.parse(fen)
      assert state.white_can_castle_kingside
      assert state.white_can_castle_queenside
      assert state.black_can_castle_kingside
      assert state.black_can_castle_queenside
    end

    test "with no white castling" do
      fen = "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w kq - 0 1"

      assert {:ok, state} = FEN.parse(fen)
      refute state.white_can_castle_kingside
      refute state.white_can_castle_queenside
      assert state.black_can_castle_kingside
      assert state.black_can_castle_queenside
    end

    test "with no black castling" do
      fen = "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQ - 0 1"

      assert {:ok, state} = FEN.parse(fen)
      assert state.white_can_castle_kingside
      assert state.white_can_castle_queenside
      refute state.black_can_castle_kingside
      refute state.black_can_castle_queenside
    end

    test "with no castling" do
      fen = "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w - - 0 1"

      assert {:ok, state} = FEN.parse(fen)
      refute state.white_can_castle_kingside
      refute state.white_can_castle_queenside
      refute state.black_can_castle_kingside
      refute state.black_can_castle_queenside
    end
  end
end
