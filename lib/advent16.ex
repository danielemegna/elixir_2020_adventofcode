defmodule Advent16.File do
  @enforce_keys [:rules,:your_ticket,:nearby_tickets]
  defstruct @enforce_keys

  def from_file_content(lines) do
    [rules_lines, your_ticket_lines, nearby_tickets_lines] =
      Enum.chunk_by(lines, fn l -> l == "" end) |> Enum.reject(&(&1 == [""]))

    rules = parse_rules(rules_lines)

    your_ticket = your_ticket_lines
    |> Enum.at(1)
    |> String.split(",")
    |> Enum.map(&(String.to_integer(&1)))

    nearby_tickets = nearby_tickets_lines
    |> Enum.drop(1)
    |> Enum.map(fn ticket ->
      ticket
      |> String.split(",")
      |> Enum.map(&(String.to_integer(&1)))
    end)
    |> MapSet.new()

    %__MODULE__{rules: rules, your_ticket: your_ticket, nearby_tickets: nearby_tickets}
  end

  defp parse_rules(rules_lines) do
    rules_lines
    |> Enum.reduce(MapSet.new(), fn(line, rules) ->
      try do
        rule_regex = ~r/^(.+): (\d+)-(\d+) or (\d+)-(\d+)$/
        [label,f1,t1,f2,t2] = Regex.run(rule_regex, line, capture: :all_but_first)
        parsed_rule = %{label: label, ranges: [
          { String.to_integer(f1),String.to_integer(t1) },
          { String.to_integer(f2),String.to_integer(t2) }
        ]}
        MapSet.put(rules, parsed_rule)
      rescue
        MatchError -> raise ArgumentError, message: "Cannot parse input line '#{line}'"
      end
    end)
  end
end

defmodule Advent16 do

  def resolve_first_part() do
    read_input_file_content()
    |> Advent16.File.from_file_content()
    |> error_rate_of()
  end

  def error_rate_of(%Advent16.File{} = file) do
    rules_ranges = file.rules
    |> Enum.flat_map(&(&1.ranges))

    file.nearby_tickets
    |> Enum.map(fn ticket_fields ->
      invalid_ticket_fields = Enum.filter(ticket_fields, fn field_value ->
        is_invalid_for_every_rule?(field_value, rules_ranges)
      end)
      Enum.sum(invalid_ticket_fields)
    end)
    |> Enum.sum
  end

  defp is_invalid_for_every_rule?(field_value, rules_ranges) do
    Enum.all?(rules_ranges, fn rule_range ->
      !is_valid_for(field_value, rule_range)
    end)
  end

  defp is_valid_for(field_value, _rule_range = {r_min, r_max}), do:
    field_value >= r_min && field_value <= r_max

  defp read_input_file_content do
    File.stream!("advent16.txt")
    |> Stream.map(&String.trim/1)
  end

end
