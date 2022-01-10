defmodule Advent18Test do
  use ExUnit.Case

  test "resolve first part" do
    assert Advent18.resolve_first_part() == 4297397455886
  end

  describe "evaluate_expression" do
    
    test "very simple" do
      assert Advent18.evaluate_expression("1 + 2") == 3
      assert Advent18.evaluate_expression("2 * 3") == 6
      assert Advent18.evaluate_expression("12 * 2") == 24
      assert Advent18.evaluate_expression("10 + 10") == 20
    end

    test "complex without parentheses" do
      assert Advent18.evaluate_expression("1 + 2 * 3 + 4 * 5 + 6") == 71
    end

    test "with parentheses" do
      assert Advent18.evaluate_expression("2 * 3 + (4 * 5)") == 26
    end

    test "complex provided examples" do
      assert Advent18.evaluate_expression("5 + (8 * 3 + 9 + 3 * 4 * 3)") == 437
      assert Advent18.evaluate_expression("5 * 9 * (7 * 3 * 3 + 9 * 3 + (8 + 6 * 4))") == 12240
      assert Advent18.evaluate_expression("((2 + 4 * 9) * (6 + 9 * 8 + 6) + 6) + 2 + 4 * 2") == 13632
    end

  end
end
