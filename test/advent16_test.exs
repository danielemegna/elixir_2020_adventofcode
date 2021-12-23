defmodule Advent16Test do
  use ExUnit.Case

  test "parse valid input file" do
    input_file_content = """
    class: 1-3 or 5-7
    row: 6-11 or 33-44
    seat: 13-40 or 45-50

    your ticket:
    7,1,14

    nearby tickets:
    7,3,47
    40,4,50
    55,2,20
    38,6,12
    """

    parsed = Advent16.parse_input_file(stream_of(input_file_content))

    expected = %TicketFile{
      rules: MapSet.new([
        %{ label: "class", ranges: [{1,3},{5,7}] },
        %{ label: "row", ranges: [{6,11},{33,44}] },
        %{ label: "seat", ranges: [{13,40},{45,50}] }
      ]),
      your_ticket: [7,1,14],
      nearby_tickets: MapSet.new([
        [7,3,47],
        [40,4,50],
        [55,2,20],
        [38,6,12]
      ])
    }
    assert parsed.rules == expected.rules
    #assert parsed == expected
  end

  defp stream_of(content), do: content |> String.split("\n") |> Stream.map(&(&1))

end
