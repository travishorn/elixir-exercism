defmodule Yacht do
  @type category ::
          :ones
          | :twos
          | :threes
          | :fours
          | :fives
          | :sixes
          | :full_house
          | :four_of_a_kind
          | :little_straight
          | :big_straight
          | :choice
          | :yacht

  @doc """
  Calculate the score of 5 dice using the given category's scoring method.
  """
  @spec score(category :: category(), dice :: [integer]) :: integer

  # All five dice showing the same face. 50 pts
  def score(:yacht, dice) do
    # Initialize two variables.
    # `first` = the first integer in the array
    # `rest` = the tail (rest of) the array
    [first | rest] = dice

    # Use Enum.all? to determine whether every integer in `rest` is equal to `first
    # If so, return 50 pts. Otherwise, 0
    if Enum.all?(rest, fn x -> x == first end), do: 50, else: 0
  end

  # 1 * the number of ones
  def score(:ones, dice) do
    # Take the dice
    dice
    # Filter out any non-1 values
    |> Enum.filter(&(&1 == 1))
    # Return the length of the array (the number of ones)
    |> length()
  end

  # 2 * the number of twos
  def score(:twos, dice) do
    # Take the dice
    dice
    # Filter out any non-2 values
    |> Enum.filter(&(&1 == 2))
    # Get the length of the array (the number of twos)
    |> length()
    # Multiply it by 2 and return
    |> Kernel.*(2)
  end

  # 3 * the number of threes
  def score(:threes, dice) do
    # Take the dice
    dice
    # Filter out any non-3 values
    |> Enum.filter(&(&1 == 3))
    # Get the length (the number of threes)
    |> length()
    # Multiply it by 3 and return
    |> Kernel.*(3)
  end

  # 4 * the number of fours
  def score(:fours, dice) do
    # Take the dice
    dice
    # Filter out any non-4 values
    |> Enum.filter(&(&1 == 4))
    # Get the length (the number of fours)
    |> length()
    # Multiply it by 4 and return
    |> Kernel.*(4)
  end

  # 5 * the number of fives
  def score(:fives, dice) do
    # Take the dice
    dice
    # Filter out any non-5 values
    |> Enum.filter(&(&1 == 5))
    # Get the length (the number of fives)
    |> length()
    # Multiply it by 5 and return
    |> Kernel.*(5)
  end

  # 6 * the number of sixes
  def score(:sixes, dice) do
    # Take the dice
    dice
    # Filter out any non-6 values
    |> Enum.filter(&(&1 == 6))
    # Get the length (the number of sixes)
    |> length()
    # Multiply it by 6 and return
    |> Kernel.*(6)
  end

  # 3 of one number, 2 of another. Points = total of all dice
  def score(:full_house, dice) do
    # Group the dice by value. Returns a map where there's a key for each unique number
    grouped = Enum.group_by(dice, & &1)

    # If the map is 2, we know we only have 2 unique numbers
    if (Kernel.map_size(grouped) == 2) do
      # Is there three of one number?
      three_of_one? = Enum.any?(grouped, fn {_, values} -> length(values) === 3 end)
      # Is there two of one number?
      two_of_one? = Enum.any?(grouped, fn {_, values} -> length(values) === 2 end)

      # If there's three of one number and two of another, that's a full house
      if three_of_one? and two_of_one? do
        # Return the sum of all numbers on the dice
        Enum.sum(dice)
      else
        # Not a full house; Not the right configuration. 0 pts
        0
      end
    else
      # Not a full house; More than 2 unique numbers
      0
    end
  end

  # At least four dice showing the same face. Points = total of the four dice
  def score(:four_of_a_kind, dice) do
    # Group the dice by value. Returns a map where there's a key for each unique number
    # and an array of values corresponding to each die that matches that key.
    # Example: Dice rolls of 6,6,4,6,6 would look like %{4 => [4], 6 => [6, 6, 6, 6]}
    grouped = Enum.group_by(dice, & &1)

    # Use Enum.find to find the first (and only in this case) element from the grouped
    # map where there are 4 or more values, meaning 4 or more dice came up with that
    # number. Example: {6 => [6, 6, 6, 6]}. From there, we assign the key to `key`
    found = Enum.find(grouped, fn {_key, value} -> length(value) >= 4 end)

    case found do
      # If nothing found, there is no four of a kind; 0 pts
      nil ->
        0

      # If not nil, there is a four of a kind, get the key and multiply by 4
      {key, _} ->
        key * 4
    end
  end

  # Exactly 1, 2, 3, 4, 5, but in any order. 30 pts
  def score(:little_straight, dice) do
    # Sort the array, then compare it to the exact match
    if Enum.sort(dice) == [1, 2, 3, 4, 5], do: 30, else: 0
  end

  # Exactly 2, 3, 4, 5, 6, but in any order. 30 pts
  def score(:big_straight, dice) do
    # Sort the array, then compare it to the exact match
    if Enum.sort(dice) == [2, 3, 4, 5, 6], do: 30, else: 0
  end

  # Any combination. Points = sum of dice
  def score(:choice, dice) do
    Enum.sum(dice)
  end
end
