defmodule Exner.State.KingMoves do
  @moduledoc "Generates all psuedo legal moves for a king"

  use Exner.State.Moves

  import Exner.State.Moves, only: [position_blocked?: 2]

  alias Exner.{Move, Position}

  @impl true
  @spec moves(Exner.Position.t(), Exner.State.t()) :: [Move.t()]
  def moves(position, state) do
    positions = [
      Position.up(position),
      Position.down(position),
      Position.left(position),
      Position.right(position)
    ]

    castle_moves = [
      kingside_castle(position, state),
      queenside_castle(position, state)
    ]

    moves =
      positions
      |> Enum.reject(&position_blocked?(&1, state))
      |> Enum.map(&%Move{from: position, to: &1})

    moves ++ Enum.reject(castle_moves, &is_nil/1)
  end

  @impl true
  @spec threatened_squares(Position.t(), Exner.State.t()) :: [Position.t()]
  def threatened_squares(position, state) do
    positions = [
      Position.up(position),
      Position.down(position),
      Position.left(position),
      Position.right(position)
    ]

    positions
    |> Enum.reject(&is_nil/1)
    |> Enum.reject(&position_blocked?(&1, state))
  end

  defp castle(from, state, direction_fun) do
    moves = [
      %Move{from: from, to: direction_fun.(from)},
      %Move{from: from, to: from |> direction_fun.() |> direction_fun.()}
    ]

    with {:ok, _} <- verify_open_squares(state, moves),
         {:ok, _} <- verify_not_in_check(state, from),
         {:ok, _} <- verify_no_moves_in_check(state, moves) do
      %Move{from: from, to: from |> Position.right() |> Position.right(), is_castle?: true}
    else
      _ -> nil
    end
  end

  defp kingside_castle(from, %Exner.State{white_can_castle_kingside: true} = state) do
    direction_fun =
      if state.active == :white do
        &Position.right/1
      else
        &Position.left/1
      end

    castle(from, state, direction_fun)
  end

  defp kingside_castle(_, _), do: nil

  defp queenside_castle(from, %Exner.State{white_can_castle_queenside: true} = state) do
    direction_fun =
      if state.active == :white do
        &Position.left/1
      else
        &Position.right/1
      end

    castle(from, state, direction_fun)
  end

  defp queenside_castle(_, _), do: nil

  defp verify_open_squares(state, moves) do
    result =
      moves
      |> Enum.map(fn move -> Exner.Board.at(state.board, move.to) end)
      |> Enum.all?(&is_nil/1)

    if result do
      {:ok, state}
    else
      {:error, "castling blocked"}
    end
  end

  defp verify_not_in_check(state, position) do
    threatened_squares = Exner.State.threatened_squares(state)

    if Enum.find(threatened_squares, fn square -> square == position end) do
      {:error, "already in check"}
    else
      {:ok, state}
    end
  end

  defp verify_no_moves_in_check(state, moves) do
    threatened_squares = Exner.State.threatened_squares(state)

    result =
      moves
      |> Enum.map(fn move ->
        !Enum.find(threatened_squares, fn square -> square == move.to end)
      end)
      |> Enum.all?(& &1)

    if result, do: {:ok, state}, else: {:error, "would put the king in check"}
  end
end
