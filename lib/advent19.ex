defmodule Advent19 do

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

end
