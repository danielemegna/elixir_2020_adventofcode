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

  @more_passports_file_content """
  eyr:1972 cid:100
  hcl:#18171d ecl:amb hgt:170 pid:186cm iyr:2018 byr:1926

  iyr:2019
  hcl:#602927 eyr:1967 hgt:170cm
  ecl:grn pid:012533040 byr:1946

  hcl:dab227 iyr:2012
  ecl:brn hgt:182cm pid:021572410 eyr:2020 byr:1992 cid:277

  hgt:59cm ecl:zzz
  eyr:2038 hcl:74454a iyr:2023
  pid:3556412378 byr:2007

  pid:087499704 hgt:74in ecl:grn iyr:2012 eyr:2030 byr:1980
  hcl:#623a2f

  eyr:2029 ecl:blu cid:129 byr:1989
  iyr:2014 pid:896056539 hcl:#a97842 hgt:165cm

  hcl:#888785
  hgt:164cm byr:2001 iyr:2015 cid:88
  pid:545766238 ecl:hzl
  eyr:2022

  iyr:2010 hgt:158cm hcl:#b6652a ecl:blu byr:1944 eyr:2021 pid:093154719
  """

  defp stream_of(content), do: content |> String.split("\n") |> Stream.map(&(&1))

  test "resolve first part" do
    assert 256 == Advent4.resolve_first_part()
  end

  test "resolve second part" do
    assert 198 == Advent4.resolve_second_part()
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
      passports = Advent4.passport_list_from(stream_of(@passports_file_content))

      assert Enum.count(passports) == 4
      assert Enum.any?(passports, &(match?(%{"ecl" => "gry", "pid" => "860033327", "hgt" => "183cm"}, &1)))
      assert Enum.any?(passports, &(match?(%{"iyr" => 2013, "pid" => "028048884", "byr" => 1929}, &1)))
      assert Enum.any?(passports, &(match?(%{"hcl" => "#ae17e1", "pid" => "760753108", "hgt" => "179cm"}, &1)))
      assert Enum.any?(passports, &(match?(%{"hcl" => "#cfa07d", "pid" => "166559648", "hgt" => "59in"}, &1)))
    end

    test "parse more passports from file stream" do
      passports = Advent4.passport_list_from(stream_of(@more_passports_file_content))

      assert Enum.count(passports) == 8

      assert Enum.any?(passports, &(match?(%{"pid" => "186cm", "byr" => 1926, "cid" => "100"}, &1)))
      assert Enum.any?(passports, &(match?(%{"pid" => "021572410","hcl" => "dab227", "iyr" => 2012}, &1)))
      assert Enum.any?(passports, &(match?(%{"pid" => "545766238", "iyr" => 2015, "byr" => 2001}, &1)))
      assert Enum.any?(passports, &(match?(%{"pid" => "093154719", "ecl" => "blu", "hgt" => "158cm"}, &1)))

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

    test "count valid passports in passport file stream" do
      assert 2 == Advent4.count_valid_passports(stream_of(@passports_file_content))
    end

  end

  describe "strictly passport validation:" do

    @strictly_valid_passport %{
      "byr" => 1944, # four digits; at least 1920 and at most 2002.
      "iyr" => 2010, # four digits; at least 2010 and at most 2020.
      "eyr" => 2021, # four digits; at least 2020 and at most 2030.
      "hgt" => "158cm", # a number followed by either cm or in: If cm, the number must be at least 150 and at most 193.
      "hcl" => "#b6652a", # a # followed by exactly six characters 0-9 or a-f.
      "ecl" => "blu", # exactly one of: amb blu brn gry grn hzl oth.
      "pid" => "093154719" # a nine-digit number, including leading zeroes.
    }

    test "strictly valid passport" do
      assert Advent4.strictly_valid?(@strictly_valid_passport) == true
    end

    test "byr (Birth Year) - four digits; at least 1920 and at most 2002" do
      assert validate_with(%{"byr" => 1919}) == false
      assert validate_with(%{"byr" => 2003}) == false
      assert validate_with(%{"byr" => 1990}) == true
      assert validate_with(%{"byr" => 2002}) == true
    end

    test "iyr (Issue Year) - four digits; at least 2010 and at most 2020" do
      assert validate_with(%{"iyr" => 2009}) == false
      assert validate_with(%{"iyr" => 2021}) == false
      assert validate_with(%{"iyr" => 2010}) == true
    end

    test "eyr (Expiration Year) - four digits; at least 2020 and at most 2030" do
      assert validate_with(%{"eyr" => 2019}) == false
      assert validate_with(%{"eyr" => 2031}) == false
      assert validate_with(%{"eyr" => 2020}) == true
    end

    test "hgt (Height)" do
      # a number followed by either cm or in:
      assert validate_with(%{"hgt" => ""}) == false
      assert validate_with(%{"hgt" => "123"}) == false
      assert validate_with(%{"hgt" => "155xx"}) == false
      assert validate_with(%{"hgt" => "65yy"}) == false
      assert validate_with(%{"hgt" => "ops"}) == false

      # If cm, the number must be at least 150 and at most 193.
      assert validate_with(%{"hgt" => "175cm"}) == true
      assert validate_with(%{"hgt" => "123cm"}) == false
      assert validate_with(%{"hgt" => "200cm"}) == false
      assert validate_with(%{"hgt" => "opscm"}) == false

      # If in, the number must be at least 59 and at most 76.
      assert validate_with(%{"hgt" => "60in"}) == true
      assert validate_with(%{"hgt" => "50in"}) == false
      assert validate_with(%{"hgt" => "80in"}) == false
      assert validate_with(%{"hgt" => "opsin"}) == false
    end

    test "hcl (Hair Color) - a # followed by exactly six characters 0-9 or a-f" do
      assert validate_with(%{"hcl" => ""}) == false
      assert validate_with(%{"hcl" => "ops"}) == false
      assert validate_with(%{"hcl" => "#12345"}) == false
      assert validate_with(%{"hcl" => "#0123456"}) == false
      assert validate_with(%{"hcl" => "#gbcdef"}) == false

      assert validate_with(%{"hcl" => "#123456"}) == true
      assert validate_with(%{"hcl" => "#012345"}) == true
      assert validate_with(%{"hcl" => "#abcdef"}) == true
    end

    test "ecl (Eye Color) - exactly one of: amb blu brn gry grn hzl oth" do
      assert validate_with(%{"ecl" => ""}) == false
      assert validate_with(%{"ecl" => "ops"}) == false
      assert validate_with(%{"ecl" => "123"}) == false

      assert validate_with(%{"ecl" => "amb"}) == true
      assert validate_with(%{"ecl" => "gry"}) == true
      assert validate_with(%{"ecl" => "oth"}) == true
    end

    test "pid (Passport ID) - a nine-digit number, including leading zeroes" do
      assert validate_with(%{"pid" => ""}) == false
      assert validate_with(%{"pid" => "ops"}) == false
      assert validate_with(%{"pid" => "01234567z"}) == false

      assert validate_with(%{"pid" => "012345678"}) == true
      assert validate_with(%{"pid" => "123456789"}) == true
      assert validate_with(%{"pid" => "999999999"}) == true
      assert validate_with(%{"pid" => "000000000"}) == true
    end

    test "count strictly valid passports in passport file stream" do
      assert 4 == Advent4.count_strictly_valid_passports(stream_of(@more_passports_file_content))
    end

    defp validate_with(overrides) do
      @strictly_valid_passport
      |> Map.merge(overrides)
      |> Advent4.strictly_valid?()
    end

  end

end
