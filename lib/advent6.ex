defmodule Advent6 do

  def resolve_first_part do
    read_answers_file()
    |> sum_answers()
  end

  def sum_answers(file_lines) do
    file_lines
    |> Enum.reduce({0, []}, fn
      "", {total_count, _} -> {total_count, []}
      line, {total_count, group_answers} ->
        new_answers = (String.graphemes(line) -- group_answers)
        {total_count + Enum.count(new_answers), group_answers ++ new_answers}
    end)
    |> elem(0)
  end
  
  defp read_answers_file do
    File.stream!("advent6.txt")
    |> Stream.map(&String.trim/1)
  end

end
