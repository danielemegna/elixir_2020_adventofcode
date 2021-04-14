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

######################################################

defmodule Advent14 do

  def resolve_first_part do
    read_input_file_content()
    |> parse_input_file()
    |> execute_program()
    |> Map.delete(:bitmask)
    |> Map.values()
    |> Enum.sum()
  end

  def execute_program(instructions, machine_state \\ %{})
  def execute_program([], machine_state), do: machine_state

  def execute_program([{:set_mask, mask} | rest], machine_state) do
    new_state = Map.put(machine_state, :bitmask, mask)
    execute_program(rest, new_state)
  end

  def execute_program([{:write, address, value} | rest], machine_state) do
    masked_value = BinaryCalculator.apply_bitmask(value, machine_state[:bitmask])
    new_state = Map.put(machine_state, address, masked_value)
    execute_program(rest, new_state)
  end

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
          {:write, String.to_integer(memory_address), String.to_integer(value)}
        true ->
          raise ArgumentError, message: "Cannot parse input line '#{line}'"
      end
    end)
  end

  defp read_input_file_content do
    File.stream!("advent14.txt")
    |> Stream.map(&String.trim/1)
  end

end
