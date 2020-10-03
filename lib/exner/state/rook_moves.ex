defmodule Exner.State.RookMoves do
  @moduledoc "Generates all psuedo legal moves for a rook"

  use Exner.State.Moves

  import Exner.State.Moves, only: [position_blocked?: 3]

  alias Exner.{Board, Move, Position}

  @spec moves(Exner.Position.t(), Exner.Board.t()) :: [Move.t()]
  def moves(position, board) do
    rook = Board.at(board, position)

    [
      follow_line(position, board, &Position.up/1),
      follow_line(position, board, &Position.down/1),
      follow_line(position, board, &Position.left/1),
      follow_line(position, board, &Position.right/1)
    ]
    |> Enum.flat_map(& &1)
    |> Enum.reject(&position_blocked?(&1, board, rook.color))
    |> Enum.map(&%Move{from: position, to: &1})
  end

  defp follow_line(position, board, direction_fun) do
    case direction_fun.(position) do
      nil ->
        []

      move ->
        if Board.at(board, move) == nil do
          [move | follow_line(move, board, direction_fun)]
        else
          [move]
        end
    end
  end
end
