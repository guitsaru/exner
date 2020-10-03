defmodule Exner.State.RookMoves do
  @moduledoc "Generates all psuedo legal moves for a rook"

  use Exner.State.Moves

  import Exner.State.Moves, only: [position_blocked?: 2]

  alias Exner.{Board, Move, Position}

  @spec moves(Exner.Position.t(), Exner.State.t()) :: [Move.t()]
  def moves(position, state) do
    [
      follow_line(position, state, &Position.up/1),
      follow_line(position, state, &Position.down/1),
      follow_line(position, state, &Position.left/1),
      follow_line(position, state, &Position.right/1)
    ]
    |> Enum.flat_map(& &1)
    |> Enum.reject(&position_blocked?(&1, state))
    |> Enum.map(&%Move{from: position, to: &1})
  end

  defp follow_line(position, state, direction_fun) do
    case direction_fun.(position) do
      nil ->
        []

      move ->
        if Board.at(state.board, move) == nil do
          [move | follow_line(move, state, direction_fun)]
        else
          [move]
        end
    end
  end
end
