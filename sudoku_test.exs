Code.load_file("sudoku.exs", __DIR__)

ExUnit.start
ExUnit.configure exclude: :pending, trqce: true

defmodule SudokuTemplate do
  use ExUnit.CaseTemplate

  setup do
    zero  = [ 9,   nil, 4,   nil, 7,   nil, nil, nil, 2   ]
    one   = [ nil, nil, 2,   3,   9,   nil, 6,   5,   4   ]
    two   = [ nil, nil, nil, 6,   nil, nil, 9,   7,   1   ]
    three = [ nil, nil, nil, nil, 3,   7,   5,   4,   9   ]
    four  = [   5,   9,   7,   2, nil, 6,   nil, 8,   nil ]
    five  = [ nil,   4,   1, nil, nil, nil, nil, nil, nil ]
    six   = [ nil, nil, nil,   8,   1,   3,   2, nil,   5 ]
    seven = [   1,   8,   5,   4, nil,   2,   3, nil, nil ]
    eight = [ nil,   3,   6, nil,   5,   9,   4, nil,   8 ]
    base  = [zero, one, two, three, four, five, six, seven, eight]
    { :ok, base: base }
  end
end

defmodule SudokuTest do
  use ExUnit.Case
  use SudokuTemplate, async: true

  test "create sudoku board", state do
    base = state[ :base ]
    assert Sudoku.create(base) == base

  end

  test "get row 0 from base sudoku board", state do
    base = state[ :base ]
    assert Sudoku.row(base,0) == Enum.fetch(base,0) |> elem(1)
  end

  test "get column 0 from base sudoku board", state do
    base = state[ :base ]
    column = [ 9, nil, nil, nil, 5, nil, nil, 1, nil ]
    assert Sudoku.column(base,0) == column
  end

  test "find blank positions" do
    zero  = [ 9,   nil, 4,   nil, 7,   nil, nil, nil, 2   ]
    assert Sudoku.blank_positions(zero) == [ 1, 3, 5, 6, 7 ]
  end

  test "correctly return no blank positions" do
    zero  = [ 9, 4, 7, 2 ]
    assert Sudoku.blank_positions(zero) == []
  end

  test "returns missing numbers for a row" do

  end

end
