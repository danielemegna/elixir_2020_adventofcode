defmodule Advent6 do

  def resolve_first_part do
    read_answers_file()
    |> sum_different_answers()
  end

  def sum_different_answers(file_lines) do
    answers_by_group(file_lines)
    |> Enum.map(fn group_answers ->
      group_answers |> List.flatten() |> Enum.uniq
    end)
    |> Enum.map(&Enum.count/1)
    |> Enum.sum
  end

  defp answers_by_group(file_lines) do
    file_lines
    |> Enum.chunk_by(fn l -> l == "" end)
    |> Enum.reject(&(&1 == [""]))
    |> Enum.map(fn group_answers ->
      group_answers |> Enum.map(fn person_answers ->
        String.graphemes(person_answers)
      end)
    end)
  end
  
  defp read_answers_file do
    File.stream!("advent6.txt")
    |> Stream.map(&String.trim/1)
  end

end
