defmodule Advent2Test do
  use ExUnit.Case

  test "resolve first part" do
    assert Advent2.resolve_first_part() == 625
  end

  test "password satify_policy?" do
    policy = %PasswordPolicy{ min: 1, max: 3, chr: "a" }
    assert Advent2.satify_policy?("abcde", policy) == true
    assert Advent2.satify_policy?("cdefg", policy) == false

    policy = %PasswordPolicy{ min: 2, max: 9, chr: "c" }
    assert Advent2.satify_policy?("c", policy) == false
    assert Advent2.satify_policy?("cc", policy) == true
    assert Advent2.satify_policy?("czzzzzzzc", policy) == true
    assert Advent2.satify_policy?("ccccccccc", policy) == true
    assert Advent2.satify_policy?("cccccccccc", policy) == false
  end

  test "build_policy from string" do
    assert Advent2.build_policy("1-3 a") == %PasswordPolicy{ min: 1, max: 3, chr: "a" }
    assert Advent2.build_policy("0-3 b") == %PasswordPolicy{ min: 0, max: 3, chr: "b" }
    assert Advent2.build_policy("2-9 c") == %PasswordPolicy{ min: 2, max: 9, chr: "c" }
  end

end
