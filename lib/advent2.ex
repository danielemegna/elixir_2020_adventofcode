defmodule PasswordPolicy do
  @enforce_keys [:min, :max, :chr]
  defstruct @enforce_keys
end

defmodule RightPasswordPolicy do
  @enforce_keys [:first_position, :second_position, :chr]
  defstruct @enforce_keys
end

defmodule Advent2 do

  def resolve_first_part() do
    resolve_using(&build_password_policy/1)
  end

  def resolve_second_part() do
    resolve_using(&build_right_password_policy/1)
  end

  def satify_policy?(password, %PasswordPolicy{} = policy) do
    occurencies = password
    |> String.graphemes()
    |> Enum.count(& &1 == policy.chr)

    occurencies >= policy.min &&
      occurencies <= policy.max
  end

  def satify_policy?(password, %RightPasswordPolicy{} = policy) do
    [
      String.at(password, policy.first_position - 1),
      String.at(password, policy.second_position - 1)
    ]
    |> Enum.count(&(&1 == policy.chr))
    |> Kernel.==(1)
  end

  def build_password_policy(string) do
    {min, max, chr} = password_policy_pieces(string)
    %PasswordPolicy{ min: min, max: max, chr: chr }
  end

  def build_right_password_policy(string) do
    {first_position, second_position, chr} = password_policy_pieces(string)
    %RightPasswordPolicy{ first_position: first_position, second_position: second_position, chr: chr }
  end

  defp resolve_using(build_password_policy_fn) do
    read_password_entries_from_file()
    |> Enum.map(&parse_entry/1)
    |> Enum.count(fn {policy_string, password} ->
      policy = build_password_policy_fn.(policy_string)
      password |> satify_policy?(policy)
    end)
  end

  defp parse_entry(entry) do
    entry
    |> String.split(":")
    |> Enum.map(&String.trim/1)
    |> List.to_tuple
  end

  defp password_policy_pieces(string) do
    [range, chr] = string |> String.split()
    [first, second] = range |> String.split("-") |> Enum.map(&String.to_integer(&1))
    {first, second, chr}
  end

  defp read_password_entries_from_file do
    File.stream!("advent2.txt")
    |> Stream.map(&String.trim/1)
  end

end
