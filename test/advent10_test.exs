defmodule Advent10Test do
  use ExUnit.Case

  test "resolve first part" do
    assert Advent10.resolve_first_part() == 2070
  end

  test "resolve second part" do
    assert Advent10.resolve_second_part() == 24179327893504
  end

  test "differences calc on small provided example" do
    assert Advent10.differences_calc([16, 10, 15, 5, 1, 11, 7, 19, 6, 12, 4]) == 7 * 5
  end

  test "differences calc on larger provided example" do
    input = [
      28, 33, 18, 42, 31, 14, 46, 20, 48, 47,
      24, 23, 49, 45, 19, 38, 39, 11, 1, 32,
      25, 35, 8, 17, 7, 9, 4, 2, 34, 10, 3
    ]
    assert Advent10.differences_calc(input) == 22 * 10
  end

  test "arrange combinations count on small provided example" do
    # (0), 1, 4, 5, 6, 7, 10, 11, 12, 15, 16, 19, (22)
    #
    # (0), 1, 4, 5, 6, 7, 10, 12, 15, 16, 19, (22)
    # 
    # (0), 1, 4, 5, 7, 10, 11, 12, 15, 16, 19, (22)
    # (0), 1, 4, 5, 7, 10, 12, 15, 16, 19, (22)
    # 
    # (0), 1, 4, 6, 7, 10, 11, 12, 15, 16, 19, (22)
    # (0), 1, 4, 6, 7, 10, 12, 15, 16, 19, (22)
    # (0), 1, 4, 7, 10, 11, 12, 15, 16, 19, (22)
    # (0), 1, 4, 7, 10, 12, 15, 16, 19, (22)
    assert Advent10.combinations_count([16, 10, 15, 5, 1, 11, 7, 19, 6, 12, 4]) == 8
  end

  test "single possibile combination" do
    assert Advent10.combinations_count([3,6,9,12,15]) == 1
  end
  
  test "two possibile combination" do
    # 3 6 7 8 11
    # 3 6 8 11
    assert Advent10.combinations_count([3,6,7,8,11]) == 2
  end

  test "4 possibile combination" do
    # 3 4 5 6
    # 3 5 6
    # 3 6
    # 3 4 6
    assert Advent10.combinations_count([3,4,5,6]) == 4
  end

  test "n possibile combination" do
    # (0) 3 4 5 6 7 (10)
    #
    # (0) 3 4 5 7 (10)
    # (0) 3 4 6 7 (10)
    # (0) 3 4 7 (10)
    #
    # (0) 3 5 6 7 (10)
    # (0) 3 5 7 (10)
    #
    # (0) 3 6 7 (10)
    assert Advent10.combinations_count([3,4,5,6,7]) == 7
  end

  test "arrange combinations count on larger provided example" do
    input = [
      28, 33, 18, 42, 31, 14, 46, 20, 48, 47,
      24, 23, 49, 45, 19, 38, 39, 11, 1, 32,
      25, 35, 8, 17, 7, 9, 4, 2, 34, 10, 3
    ]
    assert Advent10.combinations_count(input) == 19208
  end

end
