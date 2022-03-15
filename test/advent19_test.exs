defmodule Advent19Test do
  use ExUnit.Case

  test "resolve first part" do
    assert Advent19.resolve_first_part() == 134
  end

  test "count matches with rule" do
    rules = %{
      0 => [[4, 1, 5]],
      1 => [[2, 3], [3, 2]],
      2 => [[4, 4], [5, 5]],
      3 => [[4, 5], [5, 4]],
      4 => "a",
      5 => "b"
    }
    messages = ["ababbb", "bababa", "abbbab", "aaabbb", "aaaabbb"]

    assert Advent19.count_matches_with_rule(messages, 0, rules) == 2
  end

  test "count matches with rule - more complex provided example" do
    rules = %{
      42 => [[9, 14], [10, 1]],
      9 => [[14, 27], [1, 26]],
      10 => [[23, 14], [28, 1]],
      1 => "a",
      11 => [[42, 31]],
      5 => [[1, 14], [15, 1]],
      19 => [[14, 1], [14, 14]],
      12 => [[24, 14], [19, 1]],
      16 => [[15, 1], [14, 14]],
      31 => [[14, 17], [1, 13]],
      6 => [[14, 14], [1, 14]],
      2 => [[1, 24], [14, 4]],
      0 => [[8, 11]],
      13 => [[14, 3], [1, 12]],
      15 => [[1], [14]],
      17 => [[14, 2], [1, 7]],
      23 => [[25, 1], [22, 14]],
      28 => [[16, 1]],
      4 => [[1, 1]],
      20 => [[14, 14], [1, 15]],
      3 => [[5, 14], [16, 1]],
      27 => [[1, 6], [14, 18]],
      14 => "b",
      21 => [[14, 1], [1, 14]],
      25 => [[1, 1], [1, 14]],
      22 => [[14, 14]],
      8 => [[42]],
      26 => [[14, 22], [1, 20]],
      18 => [[15, 15]],
      7 => [[14, 5], [1, 21]],
      24 => [[14, 1]]
    }
    messages = [
      "abbbbbabbbaaaababbaabbbbabababbbabbbbbbabaaaa",
      "bbabbbbaabaabba",
      "babbbbaabbbbbabbbbbbaabaaabaaa",
      "aaabbbbbbaaaabaababaabababbabaaabbababababaaa",
      "bbbbbbbaaaabbbbaaabbabaaa",
      "bbbababbbbaaaaaaaabbababaaababaabab",
      "ababaaaaaabaaab",
      "ababaaaaabbbaba",
      "baabbaaaabbaaaababbaababb",
      "abbbbabbbbaaaababbbbbbaaaababb",
      "aaaaabbaabaaaaababaa",
      "aaaabbaaaabbaaa",
      "aaaabbaabbaaaaaaabbbabbbaaabbaabaaa",
      "babaaabbbaaabaababbaabababaaab",
      "aabbbbbaabbbaaaaaabbbbbababaaaaabbaaabba"
    ]

    assert Advent19.count_matches_with_rule(messages, 0, rules) == 3
  end

  test "match message against rules" do
    rules = %{
      0 => [[4, 1, 5]],
      1 => [[2, 3], [3, 2]],
      2 => [[4, 4], [5, 5]],
      3 => [[4, 5], [5, 4]],
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
      0 => [[4, 1, 5]],
      1 => [[2, 3], [3, 2]],
      2 => [[4, 4], [5, 5]],
      3 => [[4, 5], [5, 4]],
      4 => "a",
      5 => "b"
    }
    assert actual_message_rules == expected_message_rules
    assert actual_messages == ["ababbb", "bababa", "abbbab", "aaabbb", "aaaabbb"]
  end

  defp stream_of(content), do: content |> String.split("\n") |> Stream.map(& &1)
end
