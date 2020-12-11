defmodule PasswordPolicy do
  @enforce_keys [:min, :max, :chr]
  defstruct @enforce_keys
end

defmodule Advent2 do

  def resolve_first_part() do
    entries = read_passwords_from_file()
    Enum.count(entries, fn entry ->
      [policy_string, password] = entry
      |> String.split(":")
      |> Enum.map(&String.trim/1)

      policy = build_policy(policy_string)
      satify_policy?(password, policy)
    end)
  end

  def satify_policy?(password, policy) do
    occurencies = password
    |> String.graphemes()
    |> Enum.count(& &1 == policy.chr)

    occurencies >= policy.min &&
      occurencies <= policy.max
  end

  def build_policy(string) do
    [limits, chr] = string |> String.split()
    [min, max] = limits |> String.split("-") |> Enum.map(&String.to_integer(&1))
    %PasswordPolicy{ min: min, max: max, chr: chr }
  end

  defp read_passwords_from_file do
    File.stream!("advent2.txt")
    |> Stream.map(&String.trim/1)
  end

end
