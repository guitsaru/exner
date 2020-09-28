defmodule Exner.State.BishopMoves do
  use Exner.State.Moves

  import Exner.State.Moves, only: [position_blocked?: 3]

  alias Exner.{Move, Position}

  @spec moves(Exner.Position.t(), Exner.Board.t()) :: [Move.t()]
  def moves(position, board) do
    bishop = board[position]

    [
      follow_diagonal(position, board, &Position.up_left/1),
      follow_diagonal(position, board, &Position.up_right/1),
      follow_diagonal(position, board, &Position.down_left/1),
      follow_diagonal(position, board, &Position.down_right/1)
    ]
    |> Enum.flat_map(& &1)
    |> Enum.reject(&position_blocked?(&1, board, bishop.color))
    |> Enum.map(&%Move{from: position, to: &1})
  end

  defp follow_diagonal(position, board, direction_fun) do
    case direction_fun.(position) do
      :error ->
        []

      move ->
        if board[move] == nil do
          [move | follow_diagonal(move, board, direction_fun)]
        else
          [move]
        end
    end
  end
end
