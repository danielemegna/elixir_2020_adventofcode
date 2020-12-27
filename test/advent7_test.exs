defmodule Advent7Test do
  use ExUnit.Case

  @bag_rules_file_content """
  light red bags contain 1 bright white bag, 2 muted yellow bags.
  dark orange bags contain 3 bright white bags, 4 muted yellow bags.
  bright white bags contain 1 shiny gold bag.
  muted yellow bags contain 2 shiny gold bags, 9 faded blue bags.
  shiny gold bags contain 1 dark olive bag, 2 vibrant plum bags.
  dark olive bags contain 3 faded blue bags, 4 dotted black bags.
  vibrant plum bags contain 5 faded blue bags, 6 dotted black bags.
  faded blue bags contain no other bags.
  dotted black bags contain no other bags.
  """

  defp stream_of(content), do: content |> String.split("\n", trim: true) |> Stream.map(&(&1))

  test "resolve first part" do
    assert Advent7.resolve_first_part() == 235
  end

  test "parse a bag rule" do
    parsed = Advent7.parse_bag_rule(
      "light red bags contain 1 bright white bag, 2 muted yellow bags."
    )

    assert parsed == {"light red", [{1, "bright white"}, {2, "muted yellow"}]}
  end

  test "parse a bag rule that no contains other bags" do
    parsed = Advent7.parse_bag_rule(
      "faded blue bags contain no other bags."
    )

    assert parsed == {"faded blue", []}
  end

  test "parse bag rules from file stream" do
    parsed = Advent7.parse_bag_rules(stream_of(@bag_rules_file_content))

    assert parsed == %{
      "light red" => [{1, "bright white"}, {2, "muted yellow"}],
      "dark orange" => [{3, "bright white"}, {4, "muted yellow"}],
      "bright white" => [{1, "shiny gold"}],
      "muted yellow" => [{2, "shiny gold"}, {9, "faded blue"}],
      "shiny gold" => [{1, "dark olive"}, {2, "vibrant plum"}],
      "dark olive" => [{3, "faded blue"}, {4, "dotted black"}],
      "vibrant plum" => [{5, "faded blue"}, {6, "dotted black"}],
      "faded blue" => [],
      "dotted black" => []
    }
  end

  test "count who can contains a bag" do
    bag_rules = stream_of(@bag_rules_file_content)
    assert 0 == Advent7.count_who_can_contains(bag_rules, "light red")
    assert 0 == Advent7.count_who_can_contains(bag_rules, "dark orange")
    assert 4 == Advent7.count_who_can_contains(bag_rules, "shiny gold")
  end

end
