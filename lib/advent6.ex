defmodule Advent6 do

  def resolve_first_part do
    read_answers_file()
    |> sum_answers()
  end

  def sum_answers(file_lines) do
    answers_by_group = file_lines
    |> Enum.chunk_by(fn l -> l == "" end)
    |> Enum.reject(&(&1 == [""]))

    answers_by_group
    |> Enum.map(fn group_answers ->
      group_answers |> Enum.flat_map(fn person_answers ->
        String.graphemes(person_answers)
      end)
      |> Enum.uniq
    end)
    |> Enum.map(&Enum.count/1)
    |> Enum.sum
  end
  
  defp read_answers_file do
    File.stream!("advent6.txt")
    |> Stream.map(&String.trim/1)
  end

end
