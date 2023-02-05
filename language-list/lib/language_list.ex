defmodule LanguageList do
  def new(), do: []
  def add(list, language), do: [language | list]
  def count(list), do: length(list)
  def functional_list?(list), do: "Elixir" in list

  def remove(list) do
    [_head | tail] = list
    tail
  end

  def first(list) do
    [head | _tail] = list
    head
  end
end
