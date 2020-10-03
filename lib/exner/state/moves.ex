defmodule Exner.State.Moves do
  @moduledoc "A behavior used to calculate psuedo legal moves for a piece type"

  alias Exner.{Move, Position, State}

  @spec __using__(any) :: any
  defmacro __using__(_opts) do
    quote do
      @behaviour Exner.State.Moves
    end
  end

  @doc "Returns all possible moves for a given position"
  @callback moves(Position.t(), State.t()) :: [Move.t()]

  @spec position_blocked?(Position.t() | :error, State.t()) :: boolean()
  def position_blocked?(nil, _state), do: true

  def position_blocked?(position, state) do
    case Exner.Board.at(state.board, position) do
      nil -> false
      piece -> piece.color == state.active
    end
  end
end
