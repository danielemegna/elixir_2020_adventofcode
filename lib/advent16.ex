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

  def resolve_second_part() do
    file = read_input_file_content()
    |> Advent16.File.from_file_content()
    |> remove_invalid_tickets()

    fields_mapping = infer_fields_mapping(file)

    fields_mapping
    |> Enum.map(fn {label,index} ->
      if(String.starts_with?(label, "departure")) do
        Enum.at(file.your_ticket, index)
      else
        1
      end
    end)
    |> Enum.product()
  end

  def infer_fields_mapping(%Advent16.File{} = file) do

    final = file.nearby_tickets
    |> Enum.reduce(%{ compatibility_map: %{}, revealed: %{}, rules: file.rules }, fn ticket, file_accumulator ->

      ticket_compatibility_map = ticket
      |> Enum.with_index
      |> Enum.reduce(%{}, fn {field_value, index}, ticket_accumulator ->
        compatible_labels = file_accumulator.rules
        |> Enum.filter(&(is_valid?(field_value, &1)))
        |> Enum.map(&(&1.label))

        Map.put(ticket_accumulator, index, compatible_labels)
      end)

      new_compatibility_map = Map.merge(file_accumulator.compatibility_map, ticket_compatibility_map, fn _index, v1, v2 ->
        MapSet.intersection(MapSet.new(v1), MapSet.new(v2)) |> Enum.to_list
      end)

      new_file_accumulator = %{ file_accumulator | compatibility_map: new_compatibility_map }
      compute_reveals(new_file_accumulator)
    end)

    final.revealed
  end

  defp compute_reveals(accumulator) do
    revealed = accumulator.compatibility_map
    |> Enum.filter(fn {_k,v} -> Enum.count(v) == 1 end)
    |> Enum.map(fn {k,[v]} -> {v,k} end)
    |> Map.new

    if(Enum.count(revealed) > 0) do
      revealed_labels = Map.keys(revealed)
      new_compatibility_map = Enum.map(accumulator.compatibility_map, fn {index, possible_labels} -> {
          index,
          possible_labels |> Enum.reject(&(Enum.member?(revealed_labels, &1)))
      } end)
      |> Enum.reject(fn {_k,v} -> Enum.empty?(v) end)
      |> Map.new

      new_accumulator = %{ accumulator |
        compatibility_map: new_compatibility_map,
        revealed: accumulator.revealed |> Map.merge(revealed),
        rules: accumulator.rules |> Enum.reject(fn %{label: rule_label} ->
          Enum.member?(revealed_labels, rule_label)
        end)
      }
      compute_reveals(new_accumulator)
    else
      accumulator
    end
  end

  def error_rate_of(%Advent16.File{} = file) do
    rules_ranges = file.rules
    |> Enum.flat_map(&(&1.ranges))

    file.nearby_tickets
    |> Enum.map(fn ticket_fields ->
      invalid_ticket_fields = Enum.filter(ticket_fields, fn field_value ->
        !is_valid?(field_value, rules_ranges)
      end)
      Enum.sum(invalid_ticket_fields)
    end)
    |> Enum.sum
  end

  defp remove_invalid_tickets(%Advent16.File{} = file) do
    %{ file | nearby_tickets:
      file.nearby_tickets |> Enum.filter(&(is_valid?(&1, file.rules)))
    }
  end

  defp is_valid?(ticket_values, rules) when is_list(ticket_values), do:
    ticket_values |> Enum.all?(&(is_valid?(&1, rules)))

  defp is_valid?(field_value, _rule = %{ranges: rule_ranges}), do:
    is_valid?(field_value, rule_ranges)

  defp is_valid?(field_value, _rule_range = {r_min, r_max}), do:
    field_value >= r_min && field_value <= r_max

  defp is_valid?(field_value, rules), do:
    rules |> Enum.any?(&(is_valid?(field_value, &1)))

  defp read_input_file_content do
    File.stream!("advent16.txt")
    |> Stream.map(&String.trim/1)
  end

end
