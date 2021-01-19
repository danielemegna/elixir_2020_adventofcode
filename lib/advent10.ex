defmodule Advent10 do

  def resolve_first_part() do
    read_adapters_list()
    |> Stream.map(&String.to_integer/1)
    |> differences_calc()
 end

  def resolve_second_part() do
    read_adapters_list()
    |> Stream.map(&String.to_integer/1)
    |> arrange_combinations_count()
 end

  def differences_calc(seq) do
    differences = seq
    |> connect_all()
    |> differences_in()

    Enum.count(differences, &(&1 == 1)) *
      Enum.count(differences, &(&1 == 3))
  end

  def arrange_combinations_count(seq) do
    {_, [{0, return} | _]} = seq
    |> connect_all()
    |> Enum.reverse
    |> Enum.reduce({[], []}, fn(n, {list, results}) ->
      new_list = list ++ [n]
      result = foooo(new_list, results)
      {new_list, [{n, result} | results]}
    end)

    return
  end

  defp foooo([_], _), do: 1

  defp foooo(list, results) do
    [head | _] = list |> Enum.reverse()

    results
    |> Enum.take(3)
    |> Enum.reduce(0, fn {k,v}, acc ->
      if(k-head <= 3) do
        acc + v
      else
        acc
      end
    end)
  end


  defp connect_all(seq) do
    seq
    |> Enum.sort()
    |> List.insert_at(0, 0) # charging outlet
    |> List.insert_at(-1, Enum.max(seq) + 3) # device's built-in adapter
  end

  defp differences_in(seq) do
    seq
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.map(fn [x,y] -> y-x end)
  end

  defp read_adapters_list() do
    File.stream!("advent10.txt")
    |> Stream.map(&String.trim/1)
  end

end
