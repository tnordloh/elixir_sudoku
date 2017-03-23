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
    |> cells_with_index
    |> Enum.reduce(%{}, fn(cell, acc) -> 
      [row, column, value] = cell
      block = div(row,3) * 3 + div(column,3)
      Map.merge(acc, %{ [row, column, block] => value} )
    end)
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
    |> Enum.map( fn(row) -> "|#{row_to_s(row)}|" end)
    |> List.insert_at(6, "-------------")
    |> List.insert_at(3, "-------------")
    |> Enum.join("\n")
  end

  def row(list, number) do 
    {:ok, rv } = Enum.fetch( list,number )
    rv
  end

  def cells_with_index(list) do
    list
    |> Stream.with_index
    |> Enum.map( fn( {row, row_index} ) -> 
      row
      |> Stream.with_index
      |> Enum.map( fn { cell, column_index } ->
        [row_index, column_index, cell]
      end ) 
    end )
    |> List.flatten
    |> Enum.chunk(3)
  end

  def unsolved?(list) do
    list
    |> cells_with_index
    |> Enum.any?(fn(cell) ->
      [_, _, value] = cell
      value == nil
    end)
  end

  def column(list, number) do 
    Enum.map( list, fn(row) ->  Enum.fetch!(row,number)  end)
  end

  def block(list, row, column) do
    block(list,div(row,3) * 3 + div(column,3) )
  end
  def block(list, number) do
    to_map(list)
    |> Map.keys
    |> Enum.filter( fn([_,_,block]) -> 
      block == number
    end)
    |> Enum.map(fn(key) -> 
      to_map(list)[key]
    end)
  end

  def blank_positions(list) do
    cells_with_index(list)
    |> Enum.reduce([], fn([ row, column, value ], acc) ->
      if value == nil do
        acc ++ [[ row, column]]
      else
        acc
      end
    end)
  end

  def fill_cell(list) do
    [ target_row, target_column ] = fillable_cell(list)
    row = Enum.fetch!(list,target_row)

    modified_row = List.replace_at(row,
                                   target_column,
                                   List.first(possibilities(list, { :cell, target_row, target_column })) )
    List.replace_at(list, target_row, modified_row)
  end

  def fillable_cell(list) do
    list
    |> blank_positions
    |> Enum.find( fn([row, column]) ->
      possibilities(list, { :cell, row, column }) |> length == 1
    end)
  end

  def possibilities(list), do: [ 1, 2, 3, 4, 5, 6, 7, 8, 9 ] -- list
  def possibilities(list, { :cell, row, column }) do
    row_block_column = row(list,row) ++ column(list,column) ++ block(list,row,column)
    possibilities(row_block_column)
  end
  def possibilities(list, {:row, index} ) do
    possibilities(row(list,index))
  end
  def possibilities(list, {:column, index} ) do
    possibilities(column(list,index))
  end
  def possibilities(list, {:block, row, column} ) do
    possibilities(block(list,row, column))
  end
  def possibilities(list, {:block, index} ) do
    possibilities(block(list,index))
  end

end
