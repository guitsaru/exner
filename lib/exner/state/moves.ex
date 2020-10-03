defmodule Exner.State.Moves do
  alias Exner.{Board, Move, Position}

  defmacro __using__(_opts) do
    quote do
      @behaviour Exner.State.Moves
    end
  end

  @doc "Returns all possible moves for a given position"
  @callback moves(Position.t(), Board.t()) :: [Move.t()]

  @spec position_blocked?(Position.t() | :error, Board.t(), Exner.Color.t()) :: boolean()
  def position_blocked?(:error, _board, _color), do: true

  def position_blocked?(position, board, color) do
    case Board.at(board, position) do
      nil -> false
      piece -> piece.color == color
    end
  end
end
