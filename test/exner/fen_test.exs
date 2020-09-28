defmodule Exner.FENTest do
  use ExUnit.Case, async: true

  alias Exner.FEN

  describe "parse/1" do
    test "with an invalid FEN" do
      assert {:error, _} = FEN.parse("Z")
    end

    test "with starting board FEN" do
      fen = "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1"
      assert {:ok, %_{board: board}} = FEN.parse(fen)
      assert board[4].color == :white
      assert board[4].role == :queen
      assert board[60].color == :black
      assert board[60].role == :queen
    end

    test "with another board FEN" do
      fen = "rnbqkbnr/pppppppp/8/8/8/P7/1PPPPPPP/RNBQKBNR w KQkq - 0 1"
      assert {:ok, %_{board: board}} = FEN.parse(fen)
      assert board[17].color == :white
      assert board[17].role == :pawn
    end
  end
end
