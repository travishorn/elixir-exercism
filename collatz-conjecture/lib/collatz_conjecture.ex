defmodule CollatzConjecture do
  @doc """
  calc/1 takes an integer and returns the number of steps required to get the
  number to 1 when following the rules:
    - if number is odd, multiply with 3 and add 1
    - if number is even, divide by 2
  """
  @spec calc(input :: pos_integer()) :: non_neg_integer()

  # If the input is 1, the number of steps required is 0
  def calc(input) when input == 1, do: 0

  # If the input is greater than 1 and even
  def calc(input) when input > 1 and rem(input, 2) == 0 do
    # Add 1 to the number of steps, plus any remaining steps after
    # dividing the input by 2
    1 + calc(div(input, 2))
  end

  # If the input is greater than 1 and odd
  def calc(input) when input > 1 and rem(input, 2) != 0 do
    # Add 1 to the number of steps, plus any remaining steps after
    # multiplying the input by 3 and adding 1
    1 + calc((input * 3) + 1)
  end

  # The input must not be a positive integer. Raise a FunctionClauseError.
  def calc(input), do: raise FunctionClauseError, message: "Input must be a positive integer"
end
