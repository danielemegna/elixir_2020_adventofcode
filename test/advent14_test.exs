defmodule Advent14Test do
  use ExUnit.Case

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
      {:write, 11, 8},
      {:write, 101, 7},
      {:write, 0, 8},
    ]
  end

  test "raise error on invalid input file" do
    assert_raise ArgumentError, "Cannot parse input line 'invalid line'", fn ->
      Advent14.parse_input_file(stream_of("invalid line"))
    end
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

  @tag :skip
  test "apply bitmask to decimal" do
    assert BinaryCalculator.apply_bitmask(11, "XXXXXXXXXXXXXXXXXXXXXXXXXXXXX1XXXX0X") == 73
    assert BinaryCalculator.apply_bitmask(101, "XXXXXXXXXXXXXXXXXXXXXXXXXXXXX1XXXX0X") == 101
    assert BinaryCalculator.apply_bitmask(0, "XXXXXXXXXXXXXXXXXXXXXXXXXXXXX1XXXX0X") == 64
  end

end
