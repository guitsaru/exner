defmodule Exner.Color do
  @moduledoc "This module holds the type for chess colors"

  @type t :: :white | :black

  @spec parse(String.t()) :: t()
  def parse("w"), do: :white
  def parse("b"), do: :black
end
