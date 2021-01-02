defmodule Advent9 do

  def resolve_first_part() do
    read_xmas_data()
    |> Stream.map(&String.to_integer/1)
    |> find_first_invalid(25)
  end

  def resolve_second_part() do
    sequence = read_xmas_data()
    |> Stream.map(&String.to_integer/1)
    
    # optimization knowing first part solution
    # find_encryption_weakness(sequence, find_first_invalid(sequence, 25))
    find_encryption_weakness(sequence, 556543474)
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

  def find_encryption_weakness(sequence, target) do
    sequence
    |> accumulate_to_target(%{total: 0, min: nil, max: -1}, target)
    |> case do
      :overflow -> find_encryption_weakness(Stream.drop(sequence, 1), target)
      acc -> acc.min + acc.max
    end
  end

  defp accumulate_to_target(stream, acc, target) do
    n = Enum.at(stream, 0)
    acc = %{acc |
      total: acc.total + n,
      min: min(acc.min, n),
      max: max(acc.max, n)
    }

    cond do
      acc.total > target -> :overflow
      acc.total == target -> acc
      true -> accumulate_to_target(Stream.drop(stream, 1), acc, target)
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
