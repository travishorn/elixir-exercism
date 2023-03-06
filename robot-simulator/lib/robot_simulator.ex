defmodule RobotSimulator do
  # Define a custom robot type. This should probably be more well-defined than just any()
  @type robot() :: any()

  # Custom direction type. There are 4 possible values that correspond to the 4 cardinal directions
  @type direction() :: :north | :east | :south | :west

  # Custom position type. A tuple or integers representing where the robot is on a grid
  @type position() :: {integer(), integer()}

  @doc """
  Create a Robot Simulator given an initial direction and position.

  Valid directions are: `:north`, `:east`, `:south`, `:west`
  """
  @spec create(direction, position) :: robot() | {:error, String.t()}
  # When the robot is created it is facing north at position 0,0 unless otherwise specified
  def create(direction \\ :north, position \\ {0, 0}) do
    # Is the direction valid? See if it is `in` the valid types
    if direction in [:north, :east, :south, :west] do
      # Is the position valid? Make sure it's a tuple, it has 2 values, and the values at both indexes is an integer
      if is_tuple(position) and tuple_size(position) == 2 and is_integer(elem(position, 0)) and is_integer(elem(position, 1)) do
        # Valid direction and position, create a new robot with these properties
        robot = %{
          direction: direction,
          position: position
        }

        # Return the robot
        robot
      else
        # Position is invalid, return an error tuple
        {:error, "invalid position"}
      end
    else
      # Direction is invalid, return an error tuple
      {:error, "invalid direction"}
    end
  end

  @doc """
  Simulate the robot's movement given a string of instructions.

  Valid instructions are: "R" (turn right), "L", (turn left), and "A" (advance)
  """
  @spec simulate(robot, instructions :: String.t()) :: robot() | {:error, String.t()}
  def simulate(robot, instructions) do
    # Is the instruction string valid? Check by enumerating each character. All enumerations must be true
    if Enum.all?(String.graphemes(instructions), fn instruction ->
      # If the character (aka instruction) currently being evaluated is with R, L, or A, return true.
      # Otherwise, it will return false
      instruction in ["R", "L", "A"]
    end) do
      # All instructions are valid. Create an updated robot. Start with the set of instructions
      updated_robot = instructions

      # Break the instruction string into characters
      |> String.graphemes()

      # Enumerate over the instructions and reduce them into a final, updated robot result
      # Starting with the given robot, look at the instruction, and update the accumulator (aka current_robot)
      |> Enum.reduce(robot, fn instruction, current_robot ->
        # Conditional logic depending on the current instruction
        case instruction do
          # R means turn right
          "R" ->
            # Turning right depends on the robots current direction. Conditional logic on that direction
            case current_robot.direction do
              # Robot is facing north and turning right. Update the direction to east
              :north ->
                %{
                  current_robot | direction: :east
                }

              # Robot is facing east and turning right. Update the direction to south
              :east ->
                %{
                  current_robot | direction: :south
                }

              # Robot is facing south and turning right. Update the direction to west
              :south ->
                %{
                  current_robot | direction: :west
                }

              # Robot is facing west and turning right. Update the direction to north
              :west ->
                %{
                  current_robot | direction: :north
                }
            end

          # L means turn left
          "L" ->
            # Turning left depends on the robots current direction. Conditional logic on that direction
            case current_robot.direction do
              # Robot is facing north and turning left. Update the direction to west
              :north ->
                %{
                  current_robot | direction: :west
                }

              # Robot is facing east and turning left. Update the direction to north
              :east ->
                %{
                  current_robot | direction: :north
                }

              # Robot is facing south and turning left. Update the direction to east
              :south ->
                %{
                  current_robot | direction: :east
                }

              # Robot is facing west and turning left. Update the direction to south
              :west ->
                %{
                  current_robot | direction: :south
                }
            end

          # A mean advance. Basically, move forward one position
          "A" ->
            # Advancing depends on the current direction. Conditional logic on that direction
            case current_robot.direction do
              # Robot is facing north and advancing one position. Increment the value at the 2nd index of position.
              # This increases the "Y" position by 1. Effectively, advancing one position north
              :north ->
                %{
                  current_robot | position: {elem(current_robot.position, 0), elem(current_robot.position, 1) + 1}
                }

              # Robot is facing east and advancing one position. Increment the value at the 1st index (x) of position.
              :east ->
                %{
                  current_robot | position: {elem(current_robot.position, 0) + 1, elem(current_robot.position, 1)}
                }

              # Robot is facing south and advancing one position. Decrement the value at the 2nd index (y) of position.
              :south ->
                %{
                  current_robot | position: {elem(current_robot.position, 0), elem(current_robot.position, 1) - 1}
                }

              # Robot is facing west and advancing one position. Decrement the value at the 1st index (x) of position.
              :west ->
                %{
                  current_robot | position: {elem(current_robot.position, 0) - 1, elem(current_robot.position, 1)}
                }
            end
        end
      end)

      # Return the updated robot
      updated_robot
    else
      # Instructions contains some values that are not L, R, or A
      {:error, "invalid instruction"}
    end
  end

  @doc """
  Return the robot's direction.

  Valid directions are: `:north`, `:east`, `:south`, `:west`
  """
  @spec direction(robot) :: direction()
  def direction(robot) do
    robot.direction
  end

  @doc """
  Return the robot's position.
  """
  @spec position(robot) :: position()
  def position(robot) do
    robot.position
  end
end
