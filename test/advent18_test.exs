defmodule Advent18Test do
  use ExUnit.Case

  test "resolve first part" do
    assert Advent18.resolve_first_part() == 4297397455886
  end

  test "resolve second part" do
    assert Advent18.resolve_second_part() == 93000656194428
  end

  describe "evaluate_expression in order precedence" do
    
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

  describe "evaluate_expression in additions precedence" do

    test "very simple" do
      assert Advent18.evaluate_expression("1 + 2", AdditionsPrecedenceCalculator) == 3
      assert Advent18.evaluate_expression("2 * 3", AdditionsPrecedenceCalculator) == 6
      assert Advent18.evaluate_expression("12 * 2", AdditionsPrecedenceCalculator) == 24
      assert Advent18.evaluate_expression("10 + 10", AdditionsPrecedenceCalculator) == 20
    end

    test "complex without parentheses" do
      assert Advent18.evaluate_expression("1 + 2 * 3 + 4 * 5 + 6", AdditionsPrecedenceCalculator) == 231
    end

    test "with parentheses" do
      assert Advent18.evaluate_expression("2 * 3 + (4 * 5)", AdditionsPrecedenceCalculator) == 46
    end

    test "complex provided examples" do
      assert Advent18.evaluate_expression("5 + (8 * 3 + 9 + 3 * 4 * 3)", AdditionsPrecedenceCalculator) == 1445
      assert Advent18.evaluate_expression("5 * 9 * (7 * 3 * 3 + 9 * 3 + (8 + 6 * 4))", AdditionsPrecedenceCalculator) == 669060
      assert Advent18.evaluate_expression("((2 + 4 * 9) * (6 + 9 * 8 + 6) + 6) + 2 + 4 * 2", AdditionsPrecedenceCalculator) == 23340
    end

    test "very complex nested example" do
      assert Advent18.evaluate_expression(
        "((5 * 7 + 2) * 3 + 4 + 2) * 8 * ((4 + 9 * 7 + 2 * 9 * 3) + 8 * 5 * (6 * 4 + 3) + (3 * 8 * 2)) + 4 + 7 + 3",
        AdditionsPrecedenceCalculator
      ) == 4617531360
    end

  end

end
