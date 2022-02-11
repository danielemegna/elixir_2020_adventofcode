defmodule Advent19Test do
  use ExUnit.Case

  test "count matches with rule" do
    rules = %{
      0 => [[4,1,5]],
      1 => [[2,3],[3,2]],
      2 => [[4,4],[5,5]],
      3 => [[4,5],[5,4]],
      4 => "a",
      5 => "b"
    }
    messages = ["ababbb", "bababa", "abbbab", "aaabbb", "aaaabbb"]

    assert Advent19.count_matches_with_rule(messages, 0, rules) == 2
  end

  test "match message against rules" do
    rules = %{
      0 => [[4,1,5]],
      1 => [[2,3],[3,2]],
      2 => [[4,4],[5,5]],
      3 => [[4,5],[5,4]],
      4 => "a",
      5 => "b"
    }

    # can't match
    assert Advent19.match_with_rule?("bababa", 0, rules) == false
    assert Advent19.match_with_rule?("aaabbb", 0, rules) == false
    # matches with missing or too much elements
    assert Advent19.match_with_rule?("abba", 0, rules) == false
    assert Advent19.match_with_rule?("aaaabbb", 0, rules) == false
    # matches
    assert Advent19.match_with_rule?("ababbb", 0, rules) == true
    assert Advent19.match_with_rule?("abbbab", 0, rules) == true
    assert Advent19.match_with_rule?("aaaabb", 0, rules) == true
  end

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
