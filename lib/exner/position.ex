defmodule Exner.Position do
  @moduledoc "The position of a square on a chessboard"

  @typep square :: 1..64
  @typep rank :: :a | :b | :c | :d | :e | :f | :g | :h
  @typep file :: 1..8
  @opaque t :: %__MODULE__{square: square()}

  defstruct [:square]

  @spec parse(String.t()) :: t() | nil
  def parse(notation) do
    case String.to_charlist(notation) do
      [rank, file] ->
        square = rank - 96 + (file - 49) * 8
        validate(%__MODULE__{square: square})

      _ ->
        nil
    end
  end

  @spec up(t() | nil) :: t() | nil
  def up(nil), do: nil

  def up(position) do
    square = position.square + 8

    validate(%{position | square: square})
  end

  @spec down(t() | nil) :: t() | nil
  def down(nil), do: nil

  def down(position) do
    square = position.square - 8

    validate(%{position | square: square})
  end

  @spec left(t() | nil) :: t() | nil
  def left(nil), do: nil
  def left(%__MODULE__{square: square}) when square in [1, 9, 17, 25, 33, 41, 49, 57], do: nil

  def left(position) do
    square = position.square - 1

    validate(%{position | square: square})
  end

  @spec right(t() | nil) :: t() | nil
  def right(nil), do: nil
  def right(%__MODULE__{square: square}) when square in [8, 16, 24, 32, 40, 48, 56, 64], do: nil

  def right(position) do
    square = position.square + 1

    validate(%{position | square: square})
  end

  @spec up_left(t() | nil) :: t() | nil
  def up_left(position), do: position |> up() |> left()

  @spec up_right(t() | nil) :: t() | nil
  def up_right(position), do: position |> up() |> right()

  @spec down_left(t() | nil) :: t() | nil
  def down_left(position), do: position |> down() |> left()

  @spec down_right(t() | nil) :: t() | nil
  def down_right(position), do: position |> down() |> right()

  @spec to_string(t() | nil) :: String.t()
  def to_string(nil), do: Kernel.to_string(nil)
  def to_string(position), do: "#{rank(position)}#{file(position)}"

  @spec rank(t()) :: rank
  def rank(position) do
    square = position.square

    [Integer.mod(square - 1, 8) + 97]
    |> Kernel.to_string()
    |> String.to_atom()
  end

  @spec file(t()) :: file
  def file(position) do
    Integer.floor_div(position.square - 1, 8) + 1
  end

  defp validate(position) do
    if position.square > 0 && position.square <= 64 do
      position
    else
      nil
    end
  end
end

defimpl String.Chars, for: Exner.Position do
  @spec to_string(Exner.Position.t()) :: String.t()
  def to_string(position), do: Exner.Position.to_string(position)
end

defimpl Inspect, for: Exner.Position do
  @spec inspect(Exner.Position.t(), Inspect.Opts.t()) :: String.t()
  def inspect(position, _options), do: Exner.Position.to_string(position)
end
