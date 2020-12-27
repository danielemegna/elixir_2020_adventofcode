defmodule Advent7 do

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

end
