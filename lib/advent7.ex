defmodule Advent7 do

  def resolve_first_part() do
    read_bag_rules_file()
    |> count_who_can_contains("shiny gold")
  end

  def resolve_second_part() do
    read_bag_rules_file()
    |> how_many_bags_inside?("shiny gold")
  end

  def parse_bag_rules(stream) do
    stream
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

  def count_who_can_contains(bag_rules_stream, subject) do
    who_can_contains?(subject, bag_rules_stream)
    |> Enum.count()
  end

  defp who_can_contains?(subject, %Stream{} = bag_rules_stream) do
    bag_rules_map = parse_bag_rules(bag_rules_stream)
    who_can_contains?(subject, bag_rules_map)
  end

  defp who_can_contains?(subject, bag_rules_map) do
    results = bag_rules_map
    |> Enum.filter(fn {_container, contained_list} ->
      Enum.any?(contained_list, fn{_count, contained} ->
        contained == subject
      end)
    end)
    |> Enum.map(&(elem(&1, 0)))

    who_can_contains_results = results
    |> Enum.flat_map(&(who_can_contains?(&1, bag_rules_map)))
    
    Enum.concat(results, who_can_contains_results)
    |> Enum.uniq
  end

  def how_many_bags_inside?(%Stream{} = bag_rules_stream, subject) do
    parse_bag_rules(bag_rules_stream)
    |> how_many_bags_inside?(subject)
  end

  def how_many_bags_inside?(bag_rules_map, subject) do
    bag_rules_map
    |> Map.get(subject)
    |> Enum.map(fn{count, contained} ->
      count * (1 + how_many_bags_inside?(bag_rules_map, contained))
    end)
    |> Enum.sum
  end

  defp read_bag_rules_file do
    File.stream!("advent7.txt")
    |> Stream.map(&String.trim/1)
  end

end
