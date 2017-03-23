defmodule Sudoku do

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
    |> hd
  end

  def column(list, number) do 
    Enum.map( list, fn(row) ->  Enum.fetch!(row,number)  end)
  end

  def block(list, row, column) do
    block(list,div(row,3) * 3 + div(column,3) )
  end
  def block(list, number) do
    rows    = (div(number,3) * 3)..(div(number,3) * 3 + 2)
    column = rem(number,3)
    rows 
    |> Enum.map( fn(row_index) -> 
      Enum.fetch!(list,row_index)
      |> Enum.chunk(3)
      |> Enum.fetch!(column)
    end)
    |> List.flatten()
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
