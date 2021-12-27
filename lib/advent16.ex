defmodule Advent16.File do
  @enforce_keys [:rules,:your_ticket,:nearby_tickets]
  defstruct @enforce_keys
end

defmodule Advent16 do

  def parse_input_file(lines) do
    [rules_lines, your_ticket_lines, nearby_tickets_lines] =
      Enum.chunk_by(lines, fn l -> l == "" end) |> Enum.reject(&(&1 == [""]))

    rules = Enum.reduce(rules_lines, MapSet.new(), fn(l, rules) ->
      try do
        rule_regex = ~r/^(.+): (\d+)-(\d+) or (\d+)-(\d+)$/
        [label,f1,t1,f2,t2] = Regex.run(rule_regex, l, capture: :all_but_first)
        parsed_rule = %{label: label, ranges: [
          { String.to_integer(f1),String.to_integer(t1) },
          { String.to_integer(f2),String.to_integer(t2) }
        ]}
        MapSet.put(rules, parsed_rule)
      rescue
        MatchError -> line_parse_error(l)
      end
    end)

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

    %Advent16.File{rules: rules, your_ticket: your_ticket, nearby_tickets: nearby_tickets}
  end

  defp line_parse_error(line) do
    raise ArgumentError, message: "Cannot parse input line '#{line}'"
  end

end
