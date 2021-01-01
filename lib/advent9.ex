defmodule Advent9 do

  def resolve_first_part() do
    read_xmas_data()
    |> Stream.map(&String.to_integer/1)
    |> find_first_invalid(25)
  end

  def find_first_invalid(sequence, window_size) do
    preamble = sequence |> Enum.take(window_size)
    to_validate = sequence |> Enum.at(window_size)

    if !valid?(to_validate, preamble) do
      to_validate
    else
      find_first_invalid(Stream.drop(sequence, 1), window_size)
    end
  end

  def valid?(_, []), do: false

  def valid?(number, [x | rest]) do
    rest
    |> Enum.any?(fn y -> x + y == number end)
    |> if(do: true, else: valid?(number, rest))
  end

  defp read_xmas_data() do
    File.stream!("advent9.txt")
    |> Stream.map(&String.trim/1)
  end

end
