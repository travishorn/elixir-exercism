defmodule ProteinTranslation do
  @doc """
  Given an RNA string, return a list of proteins specified by codons, in order.
  """
  @spec of_rna(String.t()) :: {:ok, list(String.t())} | {:error, String.t()}

  def of_rna(rna) when rna == "" do
    {:ok, []}
  end

  def of_rna(rna) do
    # Store codons in a variable, starting with the rna string...
    codons = rna
    # Split it into a list of characters
    # Must use trim: true otherwise the first and last items will be ""
    |> String.split("", trim: true)
    # Chunk those characters into groups of 3
    |> Enum.chunk_every(3)
    # Join the characters in each chunk into a string
    |> Enum.map(&Enum.join(&1))

    # Take those codon chunks and reduce them into a new list using reduce_while
    # With this function, we can stop reducing at any point
    proteins = Enum.reduce_while(codons, [], fn codon, acc ->
      # Get the protein that corresponds to the codon
      protein = of_codon(codon)

      # Depeding on the corresponding protein...
      case protein do
        # If it's a STOP protein, halt the process and return what we have so
        # far
        {:ok, "STOP"} ->
          {:halt, acc}

        # If it's an error, the RNA strand must be invalid. Halt, but also add
        # that error to the list
        {:error, _message} ->
          {:halt, [protein | acc]}

        # If it's a valid protein, add it to the list and continue
        {:ok, _value} ->
          {:cont, [protein | acc]}
      end
    end)
    # Proteins were pushed into the list in reverse order, so we reverse the
    # whole list so it's back in the correct order
    |> Enum.reverse()

    # Do something different depending on the last item in the list
    case List.last(proteins) do
      # If there are no items in the list
      nil ->
        # Return ok with an empty list
        {:ok, []}

      # If the last item is an error
      {:error, _message} ->
        # The RNA string we were given is invalid
        {:error, "invalid RNA"}

      # If the last item is ok, that means we got to the end of the strand
      # without errors
      {:ok, _protein} ->
        # Return ok, but we can't just return the list of proteins as they are
        # represented as tuples where the 2nd value is the actual protein
        # string. Map over the list, pulling out the 2nd value of each tuple
        {:ok, proteins |> Enum.map(fn {_, protein} -> protein end)}
    end
  end

  @doc """
  Given a codon, return the corresponding protein

  UGU -> Cysteine
  UGC -> Cysteine
  UUA -> Leucine
  UUG -> Leucine
  AUG -> Methionine
  UUU -> Phenylalanine
  UUC -> Phenylalanine
  UCU -> Serine
  UCC -> Serine
  UCA -> Serine
  UCG -> Serine
  UGG -> Tryptophan
  UAU -> Tyrosine
  UAC -> Tyrosine
  UAA -> STOP
  UAG -> STOP
  UGA -> STOP
  """
  @spec of_codon(String.t()) :: {:ok, String.t()} | {:error, String.t()}
  def of_codon(codon) do
    case codon do
      _ when codon in ["UGU", "UGC"] -> {:ok, "Cysteine"}
      _ when codon in ["UUA", "UUG"] -> {:ok, "Leucine"}
      "AUG" -> {:ok, "Methionine"}
      _ when codon in ["UUU", "UUC"] -> {:ok, "Phenylalanine"}
      _ when codon in ["UCU", "UCC", "UCA", "UCG"] -> {:ok, "Serine"}
      "UGG" -> {:ok, "Tryptophan"}
      _ when codon in ["UAU", "UAC"] -> {:ok, "Tyrosine"}
      _ when codon in ["UAA", "UAG", "UGA"] -> {:ok, "STOP"}
      _ -> {:error, "invalid codon"}
    end
  end
end
