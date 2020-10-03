defmodule Exner.Board do
  @moduledoc "A chess board"

  alias Exner.{Move, Piece, Position}
  alias Exner.{Move, Piece, Position}

  defstruct pieces: %{}

  @type piece_map :: %{optional(Position.t()) => Piece.t()}
  @opaque t :: %__MODULE__{pieces: piece_map()}

  @spec new :: t()
  def new do
    {:ok, state} = Exner.FEN.starting_board()

    state.board
  end

  @spec new(piece_map) :: t()
  def new(pieces) do
    %__MODULE__{pieces: pieces}
  end

  @spec at(t(), Position.t()) :: Piece.t() | nil
  def at(board, position) do
    board.pieces[position]
  end

  @spec pieces(t()) :: [{Position.t(), Piece.t()}]
  def pieces(board), do: Enum.to_list(board.pieces)

  @spec move(t(), Move.t()) :: {:ok, t()} | {:error, String.t()}
  def move(board, move) do
    piece = at(board, move.from)

    case piece do
      nil ->
        {:error, "there is no piece at #{move}"}

      _ ->
        pieces =
          board.pieces
          |> Map.delete(move.from)
          |> Map.put(move.to, piece)

        {:ok, %{board | pieces: pieces}}
    end
  end
end

defimpl String.Chars, for: Exner.Board do
  @spec to_string(Exner.Board.t()) :: String.t()
  def to_string(board) do
    line = "\n+---+---+---+---+---+---+---+---+\n"

    ranks =
      8..1
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
