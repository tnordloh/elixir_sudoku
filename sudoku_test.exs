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
    zero_after_insert = 
            [ 9,   nil, 4,   nil, 7,   nil, 8, nil, 2   ]
    base  = [zero, one, two, three, four, five, six, seven, eight]
    base_after_insert  = [zero_after_insert, one, two, three, four, five, six, seven, eight]
    { :ok, base: base , base_after_insert: base_after_insert }
  end
end

defmodule SudokuTest do
  use ExUnit.Case
  use SudokuTemplate, async: true

  test "get row 0 from base sudoku board", %{base: base} do
    assert Sudoku.row(base,0) == Enum.fetch(base,0) |> elem(1)
  end

  test "get column 0 from base sudoku board", %{base: base} do
    column = [ 9, nil, nil, nil, 5, nil, nil, 1, nil ]
    assert Sudoku.column(base,0) == column
  end

  test "get block 2 (0 indexed, reading left to right)", %{base: base} do 
    block = [ nil, nil, 2, 6, 5, 4, 9, 7, 1 ]
    assert Sudoku.block(base,2) == block
  end

  test "get block that contains cell 0,6", %{base: base} do
    block = [ nil, nil, 2, 6, 5, 4, 9, 7, 1 ]
    assert Sudoku.block(base,0,6) == block
  end

  test "can stream cells with indexes" do
    zero  = [[ 9,   nil, 4  ]]
    assert Sudoku.cells_with_index(zero) == [ [0,0,9], [0,1,nil], [0,2,4] ]
  end

  test "can fill a cell with only one variable to fill", %{base: base, base_after_insert: base_after_insert} do
    assert Sudoku.fill_cell(base) == base_after_insert
  end

  test "can find a cell with only one variable to fill", %{base: base} do
    assert Sudoku.fillable_cell(base) == [ 0, 6 ]
  end

  test "find blank positions" do
    zero  = [[ 9,   nil, 4,   nil, 7,   nil, nil, nil, 2   ]]
    assert Sudoku.blank_positions(zero) == [ [0,1], [0,3], [0,5], [0,6], [0,7] ]
  end

  test "correctly return no blank positions" do
    zero  = [[ 9, 4, 7, 2 ]]
    assert Sudoku.blank_positions(zero) == []
  end

  test "returns missing numbers for a column", state do
    assert Sudoku.possibilities(state[:base], {:column, 0})  == [2,3,4,6,7,8]
  end

  test "returns missing numbers for a row", state do
    assert Sudoku.possibilities(state[:base], {:row, 0})  == [1,3,5,6,8]
  end


  test "returns missing numbers for a block", state do
    assert Sudoku.possibilities(state[:base], {:block, 2})  == [3,8]
  end

  test "returns missing numbers row/column/block", state do
    assert Sudoku.possibilities(state[:base], {:cell, 0, 6 })  == [8]
  end


end
