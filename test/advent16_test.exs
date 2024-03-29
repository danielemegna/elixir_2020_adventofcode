defmodule Advent16Test do
  use ExUnit.Case

  test "resolve first part" do
    assert Advent16.resolve_first_part() == 27898
  end

  test "resolve second part" do
    assert Advent16.resolve_second_part() == 2766491048287
  end

  test "infer_fields_mapping from file" do
    file = %Advent16.File{
      rules: MapSet.new([
        %{ label: "class", ranges: [{0,1},{4,19}] },
        %{ label: "row", ranges: [{0,5},{8,19}] },
        %{ label: "seat", ranges: [{0,13},{16,19}] }
      ]),
      your_ticket: [],
      nearby_tickets: MapSet.new([
        [3,9,18],
        [15,1,5],
        [5,14,9]
      ])
    }

    actual = Advent16.infer_fields_mapping(file)

    assert actual == %{"class" => 1, "row" => 0, "seat" => 2}
  end

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

    parsed = Advent16.File.from_file_content(stream_of(input_file_content))

    expected = %Advent16.File{
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
    assert parsed == expected
  end

  test "calc error rate of a file" do
    file = %Advent16.File{
      rules: MapSet.new([
        %{ label: "class", ranges: [{1,3},{5,7}] },
        %{ label: "row", ranges: [{6,11},{33,44}] },
        %{ label: "seat", ranges: [{13,40},{45,50}] }
      ]),
      your_ticket: [],
      nearby_tickets: MapSet.new([
        [7,3,47],
        [40,4,50],
        [55,2,20],
        [38,6,12]
      ])
    }

    assert Advent16.error_rate_of(file) == 4 + 55 + 12
  end

  defp stream_of(content), do: content |> String.split("\n") |> Stream.map(&(&1))

end
