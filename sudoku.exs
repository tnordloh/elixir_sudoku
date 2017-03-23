defmodule Sudoku do

  def map(raw_data) when is_list(raw_data) do
    raw_data
    |> Enum.map( fn(cell) ->
      if cell == " " do
        nil
      else
        String.to_integer(cell)
      end
    end)
    |> Enum.chunk(9)
  end

  def map(string) when is_binary(string) do
    String.codepoints(string)
    |> Enum.reduce([], fn(cell, acc) -> 
      if cell == "\n" || cell == 10 do
        acc
      else
        acc ++ [ cell ]
      end
    end)
    |> map
  end

  def to_map(list) do
    list
    |> List.flatten
    |> Stream.with_index
    |> Enum.reduce(%{}, fn({ cell, cell_index }, acc) -> 
      row = div(cell_index,9)
      column = rem(cell_index,9)
      block = div(row,3) * 3 + div(column,3)
      Map.merge(acc, %{ [row, column, block] => cell } )
    end)
  end

  def to_list(map) do
    map
    |> Map.keys
    |> Enum.sort
    |> Enum.map(fn(this_key) -> map[this_key] end)
    |> Enum.chunk(9)
  end

  defp row_to_s(row) do
    row
    |> Enum.map(fn(cell) ->
      if cell == nil do
        " "
      else
        cell
      end
    end) 
    |> List.insert_at(6,"|")
    |> List.insert_at(3,"|")
    |> Enum.join("")
  end

  def to_s(list) do
    list
    |> cells_with_index
    |> Enum.map(fn([_,_,value]) -> value end)
    |> Enum.chunk(9)
    |> Enum.map(fn(row) -> row_to_s(row) end)
    |> Enum.join("\n")
  end

  def cells_with_index(list) do
    to_map(list)
    |> Map.keys
    |> Enum.sort
    |> Enum.map(fn(key) ->
      [row_index, column_index, _ ] = key
      [row_index, column_index, to_map(list)[key]]
    end)
  end

  def unsolved?(board) when is_list(board), do: unsolved?(to_map(board))
  def unsolved?(board) do
    board
    |> Map.values
    |> Enum.any?(fn(value) -> value == nil end)
  end


  def values(list) do
    mapped_list = to_map(list)
    values(Map.keys(mapped_list), list)
  end
  def values(cell_addresses, list) do
    to_map(list)
    |> Map.take(cell_addresses)
    |> Map.values
    |> Enum.sort
  end

  def row(list, number) do 
    to_map(list)
    |> Map.keys
    |> Enum.filter( fn([row,_,_]) -> row == number end)
    |> values(list)
  end

  def column(list, number) do 
    to_map(list)
    |> Map.keys
    |> Enum.filter( fn([_,column,_]) -> column == number end)
    |> values(list)
  end

  def block(list, row, column) do
    block(list,div(row,3) * 3 + div(column,3) )
  end
  def block(list, number) do
    to_map(list)
    |> Map.keys
    |> Enum.filter( fn([_,_,block]) -> block == number end)
    |> values(list)
  end

  def blank_positions(list) do
    to_map(list)
    |> Map.keys
    |> Enum.filter(fn( key ) -> to_map(list)[key] == nil end)
  end

  def fill_cell(list) do
    p = possibilities(list, { :cell, fillable_cell(list) }) |> hd
    to_map(list)
    |> Map.put(fillable_cell(list), p )
    |> to_list
  end

  def fillable_cell(list) do
    list
    |> blank_positions
    |> Enum.find( fn([row, column, _]) ->
      possibilities(list, { :cell, row, column }) |> length == 1
    end)
  end

  def possibilities(list), do: [ 1, 2, 3, 4, 5, 6, 7, 8, 9 ] -- list
  def possibilities(list, { :cell, [row, column,_] } ) do
    list |> possibilities({ :cell, row, column })
  end
  def possibilities(list, { :cell, row, column }) do
    row(list,row) ++ column(list,column) ++ block(list,row,column) |> possibilities
  end

end
