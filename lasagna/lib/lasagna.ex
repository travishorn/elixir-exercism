defmodule Lasagna do
  @doc """
  Returns how many minutes the lasagna should be in the oven. According to the cooking book, the expected oven time in minutes is 40.
  """
  @spec expected_minutes_in_oven :: integer
  def expected_minutes_in_oven, do: 40

  def remaining_minutes_in_oven(minutes_elapsed), do: expected_minutes_in_oven() - minutes_elapsed
  def preparation_time_in_minutes(layers), do: layers * 2
  def total_time_in_minutes(layers, minutes_elapsed), do: preparation_time_in_minutes(layers) + minutes_elapsed
  def alarm(), do: "Ding!"
end
