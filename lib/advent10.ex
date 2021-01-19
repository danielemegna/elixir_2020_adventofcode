defmodule Advent10 do

  def resolve_first_part() do
    read_adapters_list()
    |> Stream.map(&String.to_integer/1)
    |> differences_calc()
 end

  def resolve_second_part() do
    read_adapters_list()
    |> Stream.map(&String.to_integer/1)
    |> combinations_count()
 end

  def differences_calc(seq) do
    differences = seq
    |> connect_all()
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.map(fn [x,y] -> y-x end)

    Enum.count(differences, &(&1 == 1)) *
      Enum.count(differences, &(&1 == 3))
  end

  def combinations_count(seq) do
    seq
    |> connect_all()
    |> Enum.reverse
    |> Enum.reduce([], fn(n, results) ->
      [{n, combinations_count(n, results)} | results]
    end)
    |> Enum.at(0)
    |> elem(1)
  end

  defp combinations_count(_, []), do: 1

  defp combinations_count(n, results) do
    results
    |> Enum.take(3)
    |> Enum.reduce(0, fn
      {k,v}, acc when(k-n <= 3) -> acc + v
      _, acc -> acc
    end)
  end

  defp connect_all(seq) do
    seq
    |> Enum.sort()
    |> List.insert_at(0, 0) # charging outlet
    |> List.insert_at(-1, Enum.max(seq) + 3) # device's built-in adapter
  end

  defp read_adapters_list() do
    File.stream!("advent10.txt")
    |> Stream.map(&String.trim/1)
  end

end
