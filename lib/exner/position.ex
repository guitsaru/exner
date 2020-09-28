defmodule Exner.Position do
  @moduledoc "Position calculations"

  @type t :: 1..64

  @spec up(t() | :error) :: :error | t()
  def up(position) when is_integer(position) and position < 57, do: position + 8
  def up(_), do: :error

  @spec down(t() | :error) :: :error | t()
  def down(position) when is_integer(position) and position > 8, do: position - 8
  def down(_), do: :error

  @spec left(t() | :error) :: :error | t()
  def left(position)
      when is_integer(position) and position not in [1, 9, 17, 25, 33, 41, 49, 57] do
    position - 1
  end

  def left(_), do: :error

  @spec right(t() | :error) :: :error | t()
  def right(position)
      when is_integer(position) and position not in [8, 16, 24, 32, 40, 48, 56, 64] do
    position + 1
  end

  def right(_), do: :error

  @spec up_left(t()) :: :error | t()
  def up_left(position), do: position |> up() |> left()

  @spec up_right(t()) :: :error | t()
  def up_right(position), do: position |> up() |> right()

  @spec down_left(t()) :: :error | t()
  def down_left(position), do: position |> down() |> left()

  @spec down_right(t()) :: :error | t()
  def down_right(position), do: position |> down() |> right()
end
