defmodule Advent19 do

  def resolve_first_part do
    file_lines = read_input_file_content()
    {rules, messages} = parse_input_file(file_lines)
    count_matches_with_rule(messages, 0, rules)
  end

  def count_matches_with_rule(messages, rule_number, rules) do
    messages
    |> Enum.count(&(match_with_rule?(&1, rule_number, rules)))
  end

  def match_with_rule?(message, rule_number, rules) when is_integer(rule_number) do
    rules[rule_number]
    |> Enum.any?(&(match_with_rule?(message, &1, rules)))
  end

  def match_with_rule?("", [], _), do: true
  def match_with_rule?("", _, _), do: false
  def match_with_rule?(_, [], _), do: false
  def match_with_rule?(message, [start_of_rule | rest_of_rule] = _rule, rules) do
    translated_start_of_rule = rules[start_of_rule]
    match_with?(message, translated_start_of_rule, rest_of_rule, rules)
  end

  defp match_with?(message, string, rest_of_rule, rules) when is_binary(string) do
    if(String.starts_with?(message, string)) do
      new_message = String.slice(message, 1..-1)
      match_with_rule?(new_message, rest_of_rule, rules)
    else
      false
    end
  end

  defp match_with?(message, composed_rule, rest_of_rule, rules) when is_list(composed_rule) do
    composed_rule
    |> Stream.map(fn partial_rule -> partial_rule ++ rest_of_rule end)
    |> Enum.any?(fn new_rule -> match_with_rule?(message, new_rule, rules) end)
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
