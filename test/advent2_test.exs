defmodule Advent2Test do
  use ExUnit.Case

  test "resolve first part" do
    assert Advent2.resolve_first_part() == 625
  end

  test "resolve second part" do
    assert Advent2.resolve_second_part() == 391
  end

  test "password satify_policy?" do
    policy = %PasswordPolicy{ min: 1, max: 3, chr: "a" }
    assert Advent2.satify_policy?("abcde", policy) == true
    assert Advent2.satify_policy?("cdefg", policy) == false

    policy = %PasswordPolicy{ min: 2, max: 9, chr: "c" }
    assert Advent2.satify_policy?("c", policy) == false
    assert Advent2.satify_policy?("cc", policy) == true
    assert Advent2.satify_policy?("czzzzzzzz", policy) == false
    assert Advent2.satify_policy?("zzzzzzzzc", policy) == false
    assert Advent2.satify_policy?("czzzzzzzc", policy) == true
    assert Advent2.satify_policy?("ccccccccc", policy) == true
    assert Advent2.satify_policy?("cccccccccc", policy) == false
  end

  test "build_password_policy from string" do
    assert Advent2.build_password_policy("1-3 a") == %PasswordPolicy{ min: 1, max: 3, chr: "a" }
    assert Advent2.build_password_policy("0-3 b") == %PasswordPolicy{ min: 0, max: 3, chr: "b" }
    assert Advent2.build_password_policy("2-9 c") == %PasswordPolicy{ min: 2, max: 9, chr: "c" }
  end
  
  test "build_right_password_policy from string" do
    assert Advent2.build_right_password_policy("1-3 a") == %RightPasswordPolicy{ first_position: 1, second_position: 3, chr: "a" }
    assert Advent2.build_right_password_policy("0-3 b") == %RightPasswordPolicy{ first_position: 0, second_position: 3, chr: "b" }
    assert Advent2.build_right_password_policy("2-9 c") == %RightPasswordPolicy{ first_position: 2, second_position: 9, chr: "c" }
  end

  test "password satify_policy? with RightPasswordPolicy" do
    policy = %RightPasswordPolicy{ first_position: 1, second_position: 3, chr: "a" }
    assert Advent2.satify_policy?("abcde", policy) == true
    assert Advent2.satify_policy?("cdefg", policy) == false

    policy = %RightPasswordPolicy{ first_position: 2, second_position: 9, chr: "c" }
    assert Advent2.satify_policy?("czzzzzzzz", policy) == false
    assert Advent2.satify_policy?("cczzzzzzz", policy) == true
    assert Advent2.satify_policy?("zzzzzzzzc", policy) == true
    assert Advent2.satify_policy?("zczzzzzzc", policy) == false
    assert Advent2.satify_policy?("czccccccz", policy) == false
    assert Advent2.satify_policy?("ccccccccz", policy) == true
    assert Advent2.satify_policy?("ccccccccc", policy) == false
  end

end
