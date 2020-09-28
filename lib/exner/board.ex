defmodule Exner.Board do
  @moduledoc "A chess board"

  @behaviour Access

  alias Exner.{Move, Piece, Position}

  defstruct pieces: %{}

  @type piece_map :: %{optional(Position.t()) => Piece.t()}
  @type t :: %__MODULE__{pieces: piece_map()}

  @spec new :: t()
  def new do
    {:ok, state} = Exner.FEN.starting_board()

    state.board
  end

  @spec new(piece_map) :: t()
  def new(pieces) do
    %__MODULE__{pieces: pieces}
  end

  @spec move(t(), Move.t()) :: t()
  def move(board, move) do
    piece = board[move.from]

    pieces =
      board.pieces
      |> Map.delete(move.from)
      |> Map.put(move.to, piece)

    %{board | pieces: pieces}
  end

  @impl Access
  @spec fetch(t(), Position.t()) :: :error | {:ok, Piece.t()}
  def fetch(board, position) do
    if 0 < position and position <= 65 do
      Map.fetch(board.pieces, position)
    else
      :error
    end
  end

  @impl Access
  @spec pop(t(), Position.t(), nil | Piece.t()) :: {Piece.t(), t()}
  def pop(board, position, default \\ nil) do
    {value, pieces} = Map.pop(board.pieces, position, default)

    {value, %{board | pieces: pieces}}
  end

  @impl Access
  @spec get_and_update(t(), Position.t(), (Piece.t() -> :pop | {Piece.t(), Piece.t()})) ::
          {Piece.t(), t()}
  def get_and_update(board, position, fun) do
    {value, pieces} = Map.get_and_update(board.pieces, position, fun)

    {value, %{board | pieces: pieces}}
  end
end

defimpl Enumerable, for: Exner.Board do
  @type acc :: {:cont, term()} | {:halt, term()} | {:suspend, term()}
  @type result :: {:done, term()} | {:halted, term()} | {:suspended, term(), (acc() -> result())}

  @spec count(%Exner.Board{}) :: {:ok, non_neg_integer}
  def count(board = %Exner.Board{}), do: Enumerable.Map.count(board)

  @spec member?(%Exner.Board{}, {Exner.Position.t(), Exner.Piece.t()}) :: {:ok, boolean}
  def member?(board, {position, piece}), do: Enumerable.Map.member?(board, {position, piece})

  @spec slice(%Exner.Board{}) ::
          {:ok, non_neg_integer, (non_neg_integer(), pos_integer() -> [any()])}
  def slice(board), do: Enumerable.Map.slice(board.pieces)

  @spec reduce(%Exner.Board{}, acc(), (any, any -> any)) :: result
  def reduce(board, acc, fun), do: Enumerable.Map.reduce(board.pieces, acc, fun)
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
