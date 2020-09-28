defmodule Exner.Piece do
  @moduledoc "A chess piece"

  @type role :: :pawn | :knight | :bishop | :rook | :queen | :king
  @type t :: %__MODULE__{color: Exner.Color.t(), role: role()}

  defstruct [:color, :role]
end

defimpl String.Chars, for: Exner.Piece do
  @spec to_string(Exner.Piece.t()) :: String.t()
  def to_string(%Exner.Piece{color: :white, role: :pawn}) do
    "♙"
  end

  def to_string(%Exner.Piece{color: :white, role: :knight}) do
    "♘"
  end

  def to_string(%Exner.Piece{color: :white, role: :bishop}) do
    "♗"
  end

  def to_string(%Exner.Piece{color: :white, role: :rook}) do
    "♖"
  end

  def to_string(%Exner.Piece{color: :white, role: :queen}) do
    "♕"
  end

  def to_string(%Exner.Piece{color: :white, role: :king}) do
    "♔"
  end

  def to_string(%Exner.Piece{color: :black, role: :pawn}) do
    "♟︎"
  end

  def to_string(%Exner.Piece{color: :black, role: :knight}) do
    "♞"
  end

  def to_string(%Exner.Piece{color: :black, role: :bishop}) do
    "♝"
  end

  def to_string(%Exner.Piece{color: :black, role: :rook}) do
    "♜"
  end

  def to_string(%Exner.Piece{color: :black, role: :queen}) do
    "♛"
  end

  def to_string(%Exner.Piece{color: :black, role: :king}) do
    "♚"
  end
end
