defmodule Advent4Test do
  use ExUnit.Case

  @passports_file_content """
  ecl:gry pid:860033327 eyr:2020 hcl:#fffffd
  byr:1937 iyr:2017 cid:147 hgt:183cm

  iyr:2013 ecl:amb cid:350 eyr:2023 pid:028048884
  hcl:#cfa07d byr:1929

  hcl:#ae17e1 iyr:2013
  eyr:2024
  ecl:brn pid:760753108 byr:1931
  hgt:179cm

  hcl:#cfa07d eyr:2025 pid:166559648
  iyr:2011 ecl:brn hgt:59in
  """

  defp passports_file_stream() do
    @passports_file_content
      |> String.split("\n")
  end

  test "resolve first part" do
    assert 256 == Advent4.resolve_first_part()
  end

  describe "passport parsing:" do

    test "parse passport from string data" do
      map = Passport.parse("hcl:#cfa07d eyr:2025 pid:166559648 iyr:2011 ecl:brn hgt:59in")

      assert Map.keys(map) |> Enum.count == 6
      assert map["hcl"] == "#cfa07d"
      assert map["eyr"] == 2025
      assert map["hgt"] == "59in"
    end

    test "parse passport from multiple lines" do
      input = [
        "hcl:#ae17e1 iyr:2013",
        "eyr:2024",
        "ecl:brn pid:760753108 byr:1931",
        "hgt:179cm"
      ]
      map = Passport.parse(input)

      assert Map.keys(map) |> Enum.count == 7
      assert map["hcl"] == "#ae17e1"
      assert map["eyr"] == 2024
      assert map["pid"] == "760753108"
      assert map["hgt"] == "179cm"
    end

    test "parse passport list from file stream" do
      passports = Advent4.passport_list_from(passports_file_stream())

      assert Enum.count(passports) == 4
      assert Enum.any?(passports, &(match?(%{"ecl" => "gry", "pid" => "860033327", "hgt" => "183cm"}, &1)))
      assert Enum.any?(passports, &(match?(%{"iyr" => 2013, "pid" => "028048884", "byr" => 1929}, &1)))
      assert Enum.any?(passports, &(match?(%{"hcl" => "#ae17e1", "pid" => "760753108", "hgt" => "179cm"}, &1)))
      assert Enum.any?(passports, &(match?(%{"hcl" => "#cfa07d", "pid" => "166559648", "hgt" => "59in"}, &1)))
    end

  end

  describe "passport validation:" do

    test "all passport fields but 'cid' are mandatory to be valid" do
      all_fields_passport = %{
        "ecl" => "any", "pid" => "any", "eyr" => "any", "hcl" => "any",
        "byr" => "any", "iyr" => "any", "cid" => "any", "hgt" => "any"
      }
      assert false == Advent4.valid?(%{})
      assert true == Advent4.valid?(all_fields_passport)
      assert true == Advent4.valid?(all_fields_passport |> Map.delete("cid"))
      assert false == Advent4.valid?(all_fields_passport |> Map.delete("ecl"))
      assert false == Advent4.valid?(all_fields_passport |> Map.delete("hgt"))
    end

    test "count valid passwords in passport file stream" do
      assert 2 == Advent4.count_valid_passports(passports_file_stream())
    end

  end

end
