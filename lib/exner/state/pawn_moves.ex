defmodule Exner.State.PawnMoves do
  @moduledoc "Generates all psuedo legal moves for a pawn"

  use Exner.State.Moves

  alias Exner.{Board, Move, Position}

  @spec moves(Position.t(), Exner.Board.t()) :: [Move.t()]
  def moves(position, board) do
    pawn = Board.at(board, position)

    [
      default_moves(position, board, pawn.color),
      double_moves(position, board, pawn.color),
      attacks(position, board, pawn.color)
    ]
    |> Enum.flat_map(& &1)
  end

  defp default_moves(position, board, :white) do
    position
    |> Position.up()
    |> List.wrap()
    |> Enum.reject(&position_blocked?(&1, board))
    |> Enum.map(&%Move{from: position, to: &1})
  end

  defp default_moves(position, board, :black) do
    position
    |> Position.down()
    |> List.wrap()
    |> Enum.reject(&position_blocked?(&1, board))
    |> Enum.map(&%Move{from: position, to: &1})
  end

  defp double_moves(position, board, :white) do
    if Position.file(position) == 2 do
      position
      |> Position.up()
      |> Position.up()
      |> List.wrap()
      |> Enum.reject(&position_blocked?(&1, board))
      |> Enum.map(&%Move{from: position, to: &1})
    else
      []
    end
  end

  defp double_moves(position, board, :black) do
    if Position.file(position) == 7 do
      position
      |> Position.down()
      |> Position.down()
      |> List.wrap()
      |> Enum.reject(&position_blocked?(&1, board))
      |> Enum.map(&%Move{from: position, to: &1})
    else
      []
    end
  end

  defp attacks(position, board, :white) do
    attacks = [Position.up_left(position), Position.up_right(position)]

    Enum.filter(attacks, &can_attack?(&1, board, :white))
  end

  defp attacks(position, board, :black) do
    attacks = [Position.down_left(position), Position.down_right(position)]

    Enum.filter(attacks, &can_attack?(&1, board, :black))
  end

  defp position_blocked?(:error, _board), do: true

  defp position_blocked?(position, board) do
    Board.at(board, position) != nil
  end

  defp can_attack?(:error, _, _), do: false

  defp can_attack?(position, board, color) do
    case Board.at(board, position) do
      nil -> false
      %Exner.Piece{color: other} -> color != other
    end
  end
end
