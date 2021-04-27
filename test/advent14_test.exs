defmodule Advent14Test do
  use ExUnit.Case

  test "resolve first part" do
    assert Advent14.resolve_first_part() == 7477696999511
  end

  test "resolve second part" do
    assert Advent14.resolve_second_part() == 3687727854171
  end

  test "parse valid input file" do
    input_file_content = """
    mask = XXXXXXXXXXXXXXXXXXXXXXXXXXXXX1XXXX0X
    mem[8] = 11
    mem[7] = 101
    mem[8] = 0
    """

    parsed = Advent14.parse_input_file(stream_of(input_file_content))

    assert parsed == [
      {:set_mask, "XXXXXXXXXXXXXXXXXXXXXXXXXXXXX1XXXX0X"},
      {:write, 8, 11},
      {:write, 7, 101},
      {:write, 8, 0},
    ]
  end

  test "raise error on invalid input file" do
    assert_raise ArgumentError, "Cannot parse input line 'invalid line'", fn ->
      Advent14.parse_input_file(stream_of("invalid line"))
    end
  end

  test "execute program instructions in value bitmask mode and get final memory state" do
    instructions = [
      {:set_mask, "XXXXXXXXXXXXXXXXXXXXXXXXXXXXX1XXXX0X"},
      {:write, 8, 11},
      {:write, 7, 101},
      {:write, 8, 0},
    ]
    
    state = Advent14.execute_program(instructions, :value_mode)

    assert state == %{
      :bitmask => "XXXXXXXXXXXXXXXXXXXXXXXXXXXXX1XXXX0X",
      7 => 101,
      8 => 64
    }
  end

  test "execute program instructions in address bitmask mode and get final memory state" do
    instructions = [
      {:set_mask, "000000000000000000000000000000X1001X"},
      {:write, 42, 100},
      {:set_mask, "00000000000000000000000000000000X0XX"},
      {:write, 26, 1}
    ]
    
    state = Advent14.execute_program(instructions, :address_mode)

    assert state == %{
      :bitmask => "00000000000000000000000000000000X0XX",
      58 => 100, 59 => 100,
      16 => 1, 17 => 1, 18 => 1, 19 => 1,
      24 => 1, 25 => 1, 26 => 1, 27 => 1,
    }
  end

  test "execute program in value bitmask mode and get memory values sum" do
    input_file_content = """
    mask = XXXXXXXXXXXXXXXXXXXXXXXXXXXXX1XXXX0X
    mem[8] = 11
    mem[7] = 101
    mem[8] = 0
    """

    result = Advent14.execute_program_and_sum_memory_values(stream_of(input_file_content), :value_mode)
    
    assert result == 165
  end

  test "execute program in address bitmask mode and get memory values sum" do
    input_file_content = """
    mask = 000000000000000000000000000000X1001X
    mem[42] = 100
    mask = 00000000000000000000000000000000X0XX
    mem[26] = 1
    """

    result = Advent14.execute_program_and_sum_memory_values(stream_of(input_file_content), :address_mode)
    
    assert result == 208
  end

  defp stream_of(content), do: content |> String.split("\n", trim: true) |> Stream.map(&(&1))

end

######################################################

defmodule BinaryCalculatorTest do
  use ExUnit.Case

  test "convert decimal to binary string" do
    assert BinaryCalculator.decimal_to_binary_string(0) == "0"
    assert BinaryCalculator.decimal_to_binary_string(11) == "1011"
    assert BinaryCalculator.decimal_to_binary_string(73) == "1001001"
    assert BinaryCalculator.decimal_to_binary_string(101) == "1100101"
    assert BinaryCalculator.decimal_to_binary_string(64) == "1000000"
  end

  test "convert binary string to decimal" do
    assert BinaryCalculator.binary_string_to_decimal("0") == 0
    assert BinaryCalculator.binary_string_to_decimal("1011") == 11
    assert BinaryCalculator.binary_string_to_decimal("1001001") == 73
    assert BinaryCalculator.binary_string_to_decimal("1100101") == 101
    assert BinaryCalculator.binary_string_to_decimal("1000000") == 64
  end

  test "apply bitmask to decimal" do
    assert BinaryCalculator.apply_bitmask(11, "XXXXXXXXXXXXXXXXXXXXXXXXXXXXX1XXXX0X") == 73
    assert BinaryCalculator.apply_bitmask(101, "XXXXXXXXXXXXXXXXXXXXXXXXXXXXX1XXXX0X") == 101
    assert BinaryCalculator.apply_bitmask(0, "XXXXXXXXXXXXXXXXXXXXXXXXXXXXX1XXXX0X") == 64
  end

  test "apply bitmask to decimal using floating bit" do
    assert BinaryCalculator.apply_bitmask_with_floating(42, "000000000000000000000000000000X1001X") == [26, 27, 58, 59]
    assert BinaryCalculator.apply_bitmask_with_floating(26, "00000000000000000000000000000000X0XX") == [16, 17, 18, 19, 24, 25, 26, 27]
  end
end
