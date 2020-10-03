defmodule Exner.State.KnightMoves do
  use Exner.State.Moves

  import Exner.State.Moves, only: [position_blocked?: 3]

  alias Exner.{Board, Move, Position}

  @spec moves(Exner.Position.t(), Exner.Board.t()) :: [Move.t()]
  def moves(position, board) do
    knight = Board.at(board, position)

    moves = [
      position |> Position.up() |> Position.up_left(),
      position |> Position.up() |> Position.up_right(),
      position |> Position.down() |> Position.down_left(),
      position |> Position.down() |> Position.down_right(),
      position |> Position.right() |> Position.up_right(),
      position |> Position.right() |> Position.down_right(),
      position |> Position.left() |> Position.up_left(),
      position |> Position.left() |> Position.down_left()
    ]

    moves
    |> Enum.reject(&position_blocked?(&1, board, knight.color))
    |> Enum.map(&%Move{from: position, to: &1})
  end
end
