defmodule Exner.Board do
  @moduledoc "A chess board"

  alias Exner.Piece

  defstruct [:pieces]

  @type piece_map :: %{optional(non_neg_integer()) => Piece.t()}
  @type t :: %__MODULE__{pieces: piece_map()}

  @spec new :: t()
  def new do
    pieces = %{
      01 => %Piece{color: :white, role: :rook},
      02 => %Piece{color: :white, role: :knight},
      03 => %Piece{color: :white, role: :bishop},
      04 => %Piece{color: :white, role: :queen},
      05 => %Piece{color: :white, role: :king},
      06 => %Piece{color: :white, role: :bishop},
      07 => %Piece{color: :white, role: :knight},
      08 => %Piece{color: :white, role: :rook},
      09 => %Piece{color: :white, role: :pawn},
      10 => %Piece{color: :white, role: :pawn},
      11 => %Piece{color: :white, role: :pawn},
      12 => %Piece{color: :white, role: :pawn},
      13 => %Piece{color: :white, role: :pawn},
      14 => %Piece{color: :white, role: :pawn},
      15 => %Piece{color: :white, role: :pawn},
      16 => %Piece{color: :white, role: :pawn},
      49 => %Piece{color: :black, role: :pawn},
      50 => %Piece{color: :black, role: :pawn},
      51 => %Piece{color: :black, role: :pawn},
      52 => %Piece{color: :black, role: :pawn},
      53 => %Piece{color: :black, role: :pawn},
      54 => %Piece{color: :black, role: :pawn},
      55 => %Piece{color: :black, role: :pawn},
      56 => %Piece{color: :black, role: :pawn},
      57 => %Piece{color: :black, role: :rook},
      58 => %Piece{color: :black, role: :knight},
      59 => %Piece{color: :black, role: :bishop},
      60 => %Piece{color: :black, role: :queen},
      61 => %Piece{color: :black, role: :king},
      62 => %Piece{color: :black, role: :bishop},
      63 => %Piece{color: :black, role: :knight},
      64 => %Piece{color: :black, role: :rook}
    }

    new(pieces)
  end

  @spec new(piece_map) :: t()
  def new(pieces) do
    %__MODULE__{pieces: pieces}
  end
end

defimpl String.Chars, for: Exner.Board do
  @spec to_string(Exner.Board.t()) :: String.t()
  def to_string(board) do
    line = "\n+---+---+---+---+---+---+---+---+\n"

    ranks =
      1..8
      |> Enum.map(fn rank -> print_rank(rank, board) <> line end)
      |> Enum.join("")

    line <> ranks
  end

  defp print_rank(rank, board) do
    index = rank - 1
    first = 8 * index + 1
    last = first + 7

    columns =
      first..last
      |> Enum.map(fn i -> Map.get(board.pieces, i, " ") end)
      |> Enum.map(fn p -> " " <> Kernel.to_string(p) <> " " end)
      |> Enum.join("|")

    "|" <> columns <> "|"
  end
end
