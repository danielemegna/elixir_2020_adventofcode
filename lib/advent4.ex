defmodule Passport do

  def parse(passport_data) when is_list(passport_data) do
    passport_data
    |> Enum.join(" ")
    |> __MODULE__.parse()
  end

  def parse(passport_data) when is_binary(passport_data) do
    passport_data
    |> String.split(" ")
    |> Enum.reduce(%{}, fn kv, acc ->
      [k, v] = kv |> String.split(":")
      Map.put(acc, k, v)
    end)
  end

end

defmodule Advent4 do

  def resolve_first_part do
    read_passports_file()
    |> count_valid_passports()
  end

  def count_valid_passports(file_lines) do
    file_lines
    |> passport_list_from()
    |> Enum.count(&is_valid?/1)
  end

  def passport_list_from(file_lines, acc \\ [])
  def passport_list_from([], acc), do: acc
  def passport_list_from(["" | rest], acc), do: passport_list_from(rest, acc)
  def passport_list_from(file_lines, acc) do
    {current_passport, file_rest} = file_lines |> Enum.split_while(&(&1 != ""))
    acc = [Passport.parse(current_passport) | acc]
    passport_list_from(file_rest, acc)
  end

  defp is_valid?(passport) do
    passport_keys = passport |> Map.keys() |> MapSet.new()
    ["byr", "iyr", "eyr", "hgt", "hcl", "ecl", "pid"]
    |> MapSet.new()
    |> MapSet.subset?(passport_keys)
  end


  defp read_passports_file do
    File.stream!("advent4.txt")
    |> Stream.map(&String.trim/1)
  end

end
