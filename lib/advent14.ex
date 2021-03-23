defmodule BinaryCalculator do

  def decimal_to_binary_string(decimal) do
    Integer.to_string(decimal, 2)
  end
  
  def binary_string_to_decimal(binary_string) do
    {decimal, _remainder_of_binary} = Integer.parse(binary_string, 2)
    decimal
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
