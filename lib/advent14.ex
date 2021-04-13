defmodule BinaryCalculator do

  def decimal_to_binary_string(decimal) do
    Integer.to_string(decimal, 2)
  end
  
  def binary_string_to_decimal(binary_string) do
    {decimal, _remainder_of_binary} = Integer.parse(binary_string, 2)
    decimal
  end

  def apply_bitmask(decimal, bitmask) do
    binary_representation = decimal_to_binary_string(decimal) 

    reverse_bitmask = bitmask |> String.reverse
    reverse_binary_representation = binary_representation
    |> String.pad_leading(String.length(bitmask), "0")
    |> String.reverse

    [reverse_bitmask, reverse_binary_representation]
    |> Enum.map(&String.graphemes/1)
    |> Enum.zip
    |> Enum.map(fn {bitmask_item, binary_item} ->
      case bitmask_item do
        "X" -> binary_item
        override -> override
      end
    end)
    |> Enum.join()
    |> String.reverse
    |> binary_string_to_decimal
  end

end

defmodule Advent14 do

  def parse_input_file(stream) do
    Enum.map(stream, fn line ->
      set_mask_regex = ~r/^mask = (.+)$/
      write_regex = ~r/^mem\[(.+)\] = (.+)$/
      cond do
        Regex.match?(set_mask_regex, line) ->
          [mask] = Regex.run(set_mask_regex, line, capture: :all_but_first)
          {:set_mask, mask}
        Regex.match?(write_regex, line) ->
          [memory_address, value] = Regex.run(write_regex, line, capture: :all_but_first)
          {:write, String.to_integer(value), String.to_integer(memory_address)}
        true ->
          raise ArgumentError, message: "Cannot parse input line '#{line}'"
      end
    end)
  end

end
