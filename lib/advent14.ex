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

  def apply_bitmask_with_floating(decimal, bitmask) do
    binary_representation = decimal_to_binary_string(decimal) 

    reverse_bitmask = bitmask |> String.reverse
    reverse_binary_representation = binary_representation
    |> String.pad_leading(String.length(bitmask), "0")
    |> String.reverse

    masked_address = [reverse_bitmask, reverse_binary_representation]
    |> Enum.map(&String.graphemes/1)
    |> Enum.zip
    |> Enum.map(fn {bitmask_item, binary_item} ->
      case bitmask_item do
        "0" -> binary_item
        "1" -> "1"
        "X" -> "X"
      end
    end)
    |> Enum.reverse

    Enum.reduce(masked_address, [], fn char, acc ->
      case char do
        "X" -> double_and_fork(acc)
        _ -> add_to_all(acc, char)
      end
    end)
    |> Enum.map(&Enum.join/1)
    |> Enum.map(&binary_string_to_decimal/1)
    |> Enum.sort
  end

  def add_to_all([], char), do: [[char]]
  def add_to_all(list_of_lists, char) do
    Enum.map(list_of_lists, fn list -> list ++ [char] end)
  end

  def double_and_fork([]), do: [["0"], ["1"]]
  def double_and_fork(list_of_lists) do
    head = add_to_all(list_of_lists, "0")
    tail = add_to_all(list_of_lists, "1")
    head ++ tail
  end

end

######################################################

defmodule Advent14 do

  def resolve_first_part do
    read_input_file_content()
    |> execute_program_and_sum_memory_values(:value_mode)
  end

  def resolve_second_part do
    read_input_file_content()
    |> execute_program_and_sum_memory_values(:address_mode)
  end

  def execute_program_and_sum_memory_values(program_file_content_stream, bitmask_mode) do
    program_file_content_stream
    |> parse_input_file()
    |> execute_program(bitmask_mode)
    |> Map.delete(:bitmask)
    |> Map.values()
    |> Enum.sum()
  end

  def execute_program(instructions, bitmask_mode, machine_state \\ %{})
  def execute_program([], _, machine_state), do: machine_state

  def execute_program([{:set_mask, mask} | rest], bitmask_mode, machine_state) do
    new_state = Map.put(machine_state, :bitmask, mask)
    execute_program(rest, bitmask_mode, new_state)
  end

  def execute_program([{:write, address, value} | rest], :value_mode, machine_state) do
    masked_value = BinaryCalculator.apply_bitmask(value, machine_state[:bitmask])
    new_state = Map.put(machine_state, address, masked_value)
    execute_program(rest, :value_mode, new_state)
  end

  def execute_program([{:write, address, value} | rest], :address_mode, machine_state) do
    addresses = BinaryCalculator.apply_bitmask_with_floating(address, machine_state[:bitmask])
    new_state = Enum.reduce(addresses, machine_state, fn address, m_state ->
      Map.put(m_state, address, value)
    end)
    execute_program(rest, :address_mode, new_state)
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
