defmodule Advent19Test do
  use ExUnit.Case

  test "parse input file lines" do
    input_file_content = """
    0: 4 1 5
    1: 2 3 | 3 2
    2: 4 4 | 5 5
    3: 4 5 | 5 4
    4: "a"
    5: "b"

    ababbb
    bababa
    abbbab
    aaabbb
    aaaabbb
    """

    {actual_message_rules, actual_messages} = Advent19.parse_input_file(stream_of(input_file_content))

    expected_message_rules = %{
      0 => [[4,1,5]],
      1 => [[2,3],[3,2]],
      2 => [[4,4],[5,5]],
      3 => [[4,5],[5,4]],
      4 => "a",
      5 => "b"
    }
    assert actual_message_rules == expected_message_rules
    assert actual_messages == ["ababbb", "bababa", "abbbab", "aaabbb", "aaaabbb"]
  end

  defp stream_of(content), do: content |> String.split("\n") |> Stream.map(&(&1))
end
