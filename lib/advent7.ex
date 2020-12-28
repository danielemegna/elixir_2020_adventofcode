defmodule Advent7 do

  def resolve_first_part() do
    read_bag_rules_file()
    |> count_who_can_contains("shiny gold")
  end

  def parse_bag_rules(lines) do
    lines
    |> Enum.map(&parse_bag_rule/1)
    |> Map.new
  end

  def parse_bag_rule(string) do
    [container, contained] = ~r/^(.+) bags contain (.+)\.$/
    |> Regex.run(string, capture: :all_but_first)

    contained = contained
    |> String.split(",")
    |> Enum.map(&String.trim/1)
    |> Enum.reject(&(&1 == "no other bags"))
    |> Enum.map(fn c ->
      [count, bag] = ~r/^(\d+) (.+) (?:bag|bags)$/
      |> Regex.run(c, capture: :all_but_first)

      {String.to_integer(count), bag}
    end)

    {container, contained}
  end

  def count_who_can_contains(bag_rules, subject) do
    IO.inspect bag_rules
    bag_rules_map = parse_bag_rules(bag_rules)

    who_can_contains?(subject, bag_rules_map)
    |> Enum.count()
  end

  defp who_can_contains?(subject, bag_rules_map) do
    found = bag_rules_map
    |> Enum.filter(fn {_container, contained_list} ->
      Enum.any?(contained_list, fn{_count, contained} ->
        contained == subject
      end)
    end)
    |> Enum.map(&(elem(&1, 0)))
    
    found
    |> Enum.concat(Enum.flat_map(found, &(who_can_contains?(&1, bag_rules_map))))
    |> Enum.uniq
  end

  defp read_bag_rules_file do
    File.stream!("advent7.txt")
    |> Stream.map(&String.trim/1)
  end

end
