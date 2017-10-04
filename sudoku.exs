defmodule Sudoku do

  def to_board(raw_data) when is_list(raw_data) do
    raw_data
    |> Enum.map( fn " " -> nil; cell -> String.to_integer(cell) end)
    |> Enum.chunk(9)
  end
  def to_board(string) when is_binary(string) do
    Regex.scan(~r{[^\n]}, string)
    |> List.flatten
    |> to_board
  end

  def block_index(row,column) do
    div(row,3) * 3 + div(column,3)
  end

  def to_map(list) do
    list
    |> List.flatten
    |> Stream.with_index
    |> Enum.reduce(%{}, fn({ cell, cell_index }, acc) -> 
      row = div(cell_index,9)
      column = rem(cell_index,9)
      block = block_index(row,column)
      Map.merge(acc, %{ [row, column, block] => cell } )
    end)
  end

  defp row_to_s(row) do
    row
    |> Enum.map(fn nil -> " "; cell -> cell end) 
      |> List.insert_at(6,"|")
      |> List.insert_at(3,"|")
      |> Enum.join("")
  end

  def to_s(list) do
    list
    |> Map.keys
    |> Enum.sort
    |> Enum.map(fn(key) -> (list[key]) end)
    |> Enum.chunk(9)
    |> Enum.map(&(row_to_s(&1)))
    |> Enum.join("\n")
  end

  def unsolved?(board) do
    board
    |> Map.values
    |> Enum.any?(&(&1 == nil))
  end

  def row_values(board, row) do 
    fetch(board, fn [^row, _column, _block ] -> true; _key -> false end)
  end

  def column_values(board, column) do 
    fetch(board, fn [_row, ^column, _block ] -> true; _key -> false end)
  end

  def block_values(board, row, column) do
    block_values(board,block_index(row,column) )
  end
  def block_values(board, block) do
    fetch(board, fn [_row, _column, ^block ] -> true; _key -> false end)
  end

  defp fetch(board, matcher) do
    board
    |> Map.keys
    |> Enum.filter(matcher)
    |> Enum.map(fn address -> Map.fetch!(board, address) end)
  end

  def blank_positions(board) do
    board
    |> Map.keys
    |> Enum.filter(&(board[&1] == nil))
  end

  def fill_cell(board) do
    possibilities(board, { :cell, fillable_cell(board) })
    |> Enum.map(fn(possibility) -> 
      Map.put(board, fillable_cell(board), possibility )
    end)
  end

  def fillable_cell(board) do
    board
    |> blank_positions
    |> Enum.min_by( fn([row, column, _]) ->
      possibilities(board, { :cell, row, column }) |> length
    end)
  end

  def possibilities(list), do: [ 1, 2, 3, 4, 5, 6, 7, 8, 9 ] -- list
  def possibilities(board, { :cell, [row, column,_] } ) do
    board 
    |> possibilities({ :cell, row, column })
  end
  def possibilities(board, { :cell, row, column }) do
    row_values(board,row) ++
    column_values(board,column) ++
    block_values(board,row,column)
    |> possibilities
  end

  def invalid?(board) do
    board
    |> blank_positions
    |> Enum.any?(fn(position) -> 
      possibilities(board,{:cell, position } ) |> length == 0
    end)
  end

end
