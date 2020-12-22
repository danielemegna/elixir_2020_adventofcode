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
      v = typed(k, v)
      Map.put(acc, k, v)
    end)
  end

  defp typed(key, value) when key in ["byr", "iyr", "eyr"], do: String.to_integer(value)
  defp typed(_key, value), do: value

end

defmodule Advent4 do

  def resolve_first_part do
    read_passports_file()
    |> count_valid_passports()
  end

  def count_valid_passports(file_lines) do
    file_lines
    |> passport_list_from()
    |> Enum.count(&valid?/1)
  end

  def count_strictly_valid_passports(file_lines) do
    file_lines
    |> passport_list_from()
    |> Enum.count(&strictly_valid?/1)
  end

  def passport_list_from(file_lines, acc \\ [])
  def passport_list_from([], acc), do: acc
  def passport_list_from(["" | rest], acc), do: passport_list_from(rest, acc)
  def passport_list_from(file_lines, acc) do
    {current_passport, file_rest} = file_lines |> Enum.split_while(&(&1 != ""))
    acc = [Passport.parse(current_passport) | acc]
    passport_list_from(file_rest, acc)
  end

  def valid?(passport) do
    passport_keys = passport |> Map.keys() |> MapSet.new()
    ["byr", "iyr", "eyr", "hgt", "hcl", "ecl", "pid"]
    |> MapSet.new()
    |> MapSet.subset?(passport_keys)
  end

  def strictly_valid?(passport) do
    valid?(passport) && Enum.all?(passport, fn field ->
      valid_field?(field)
    end)
  end

  defp valid_field?({"byr", value}), do: value >= 1920 && value <= 2002
  defp valid_field?({"iyr", value}), do: value >= 2010 && value <= 2020
  defp valid_field?({"eyr", value}), do: value >= 2020 && value <= 2030
  defp valid_field?({"hcl", value}), do: String.match?(value, ~r/^#[0-9a-f]{6}$/)
  defp valid_field?({"ecl", value}), do: value in ["amb","blu","brn","gry","grn","hzl","oth"]
  defp valid_field?({"pid", value}), do: String.match?(value, ~r/^[0-9]{9}$/)

  # TODO refactor with a regex ?
  defp valid_field?({"hgt", value}) do
    {height, unit} = String.split_at(value, -2)
    height =
      try do
        String.to_integer(height)
        rescue _ -> -1
      end

    case unit do
      "cm" -> height >= 150 && height <= 193
      "in" -> height >= 59 && height <= 76
      _ -> false
    end
  end

  defp valid_field?(_), do: true

  defp read_passports_file do
    File.stream!("advent4.txt")
    |> Stream.map(&String.trim/1)
  end

end
