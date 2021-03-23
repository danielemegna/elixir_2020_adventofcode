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

  # iex(1)> List.to_string(:io_lib.format("~36.2.0B", [11]))
  # "000000000000000000000000000000001011"

  defp stream_of(content), do: content |> String.split("\n", trim: true) |> Stream.map(&(&1))

end
