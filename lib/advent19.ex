defmodule Advent19 do

  def resolve_first_part do
    {rules, messages} =
      read_input_file_content() |> parse_input_file()
    count_matches_with_rule(messages, 0, rules)
  end

  def count_matches_with_rule(messages, rule_number, rules) do
    messages
    |> Enum.count(fn message ->
      match_with_rule?(message, rule_number, rules)
    end)
  end

  def match_with_rule?(message, rule_number, rules) when is_integer(rule_number) do
    rule = rules[rule_number]
    match_with_rule?(message, rule, rules)
  end

  def match_with_rule?(message, [[_|_]|_] = composed_rule, rules) do
    composed_rule
    |> Enum.any?(&(match_with_rule?(message, &1, rules)))
  end

  def match_with_rule?("", [], _), do: true
  def match_with_rule?(_, [], _), do: false
  def match_with_rule?(message, rule, rules) when is_list(rule) do
    [head | rest] = rule
    head_rule = rules[head]

    case head_rule do

      s when is_binary(s) ->
        if(String.starts_with?(message, s)) do
          new_message = String.slice(message, 1..-1)
          new_rule = rest
          match_with_rule?(new_message, new_rule, rules)
        else
          false
        end

      l when is_list(l) -> # is always a list of lists 
        l
        |> Stream.map(fn partial_rule ->
          (partial_rule ++ rest)
        end)
        |> Enum.any?(fn new_rule ->
          match_with_rule?(message, new_rule, rules)
        end)

    end
  end

  def parse_input_file(lines) do
    [rules_lines, messages] = lines
    |> Enum.chunk_by(fn l -> l == "" end)
    |> Enum.reject(&(&1 == [""]))

    rules = rules_lines |> Enum.map(fn line ->
      string_rule = ~r/^(\d+): "(.+)"$/
      reference_rule = ~r/^(\d+): (.+)$/

      cond do
        (match = Regex.run(string_rule, line, capture: :all_but_first)) ->
          [rule_number, string] = match
          {String.to_integer(rule_number), string}

        (match = Regex.run(reference_rule, line, capture: :all_but_first)) ->
          [rule_number, references] = match
          parsed_references = references
          |> String.split("|")
          |> Enum.map(fn rule_numbers -> 
            rule_numbers
            |> String.split(" ", trim: true)
            |> Enum.map(&String.to_integer/1)
          end)
          {String.to_integer(rule_number), parsed_references}
      end

    end)
    |> Map.new

    {rules, messages}
  end

  defp read_input_file_content do
    File.stream!("advent19.txt")
    |> Stream.map(&String.trim/1)
  end

end
