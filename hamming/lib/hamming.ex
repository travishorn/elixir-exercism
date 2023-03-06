defmodule Hamming do
  @doc """
  Returns number of differences between two strands of DNA, known as the Hamming Distance.

  ## Examples

  iex> Hamming.hamming_distance('AAGTCATA', 'TAGCGATC')
  {:ok, 4}
  """
  @spec hamming_distance([char], [char]) :: {:ok, non_neg_integer} | {:error, String.t()}

  # Guard clause which simply returns {:ok, 0} if both arguments match
  def hamming_distance(strand, strand), do: {:ok, 0}

  # When the lengths do not match
  def hamming_distance(strand1, strand2) when length(strand1) != length(strand2) do
    # Return the expected error
    {:error, "strands must be of equal length"}
  end  

  # When the arguments do not match but their lengths do
  def hamming_distance(strand1, strand2) do
    # Zip the two arrays together to create tuples of values
    # Count how many of the tuples do not have matching values
    # Return that number next to :ok
    {:ok, Enum.count(Enum.zip(strand1, strand2), fn {a, b} -> a != b end)}
  end
end
