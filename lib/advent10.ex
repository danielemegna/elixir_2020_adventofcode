defmodule Advent10 do

  def resolve_first_part() do
    read_adapters_list()
    |> Stream.map(&String.to_integer/1)
    |> differences_calc()
 end

  def differences_calc(seq) do
    differences = seq
    |> Enum.sort()
    |> List.insert_at(0, 0) # charging outlet
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.map(fn [x,y] -> y-x end)
    |> Enum.concat([3]) # device's built-in adapter

    Enum.count(differences, &(&1 == 1)) *
      Enum.count(differences, &(&1 == 3))
  end


  defp read_adapters_list() do
    File.stream!("advent10.txt")
    |> Stream.map(&String.trim/1)
  end

end
