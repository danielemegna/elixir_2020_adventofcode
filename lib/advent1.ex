defmodule Advent1 do

  def resolve_first_part do
    read_expense_report_from_file()
    |> resolve_first_part_with()
  end

  def resolve_first_part_with(expense_report_entries) do
    [x, y] = expense_report_entries
    |> candidate_pairs_stream()
    |> find_pair_with_2020_sum()

    x * y
  end

  def resolve_second_part do
    read_expense_report_from_file()
    |> resolve_second_part_with()
  end

  def resolve_second_part_with(expense_report_entries) do
    [x, y, z] = expense_report_entries
    |> candidate_tris_stream()
    |> find_tris_with_2020_sum()

    x * y * z
  end

  defp candidate_pairs_stream(list) do
    list |> Stream.flat_map(fn x ->
      for y <- list, x != y, do: [x, y]
    end)
  end

  defp find_pair_with_2020_sum(list) do
    list |> Enum.find(fn [x, y] ->
      x + y == 2020
    end)
  end

  defp candidate_tris_stream(list) do
    list |> Stream.flat_map(fn x ->
      list |> Stream.flat_map(fn y ->
        for z <- list,
          x != y,
          x != z,
          y != z
        do
          [x, y, z]
        end
      end)
    end)
  end

  defp find_tris_with_2020_sum(list) do
    list |> Enum.find(fn [x, y, z] ->
      x + y + z == 2020
    end)
  end

  defp read_expense_report_from_file do
    File.stream!("advent1.txt")
    |> Stream.map(&String.trim/1)
    |> Stream.map(&String.to_integer/1)
  end

end
