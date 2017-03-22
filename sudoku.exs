defmodule Sudoku do

  def create( list ), do: list

  def row(list, number) do 
    {:ok, rv } = Enum.fetch( list,number )
    rv
  end

  def column(list, number) do 
    Enum.map( list, fn(row) ->  Enum.fetch!(row,number)  end)
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
    list
    |> Stream.with_index
    |> Enum.reduce([], fn({ num, idx }, acc) ->
      if num == nil do
        acc ++ [ idx ]
      else
        acc
      end
    end)
  end

  def possibilities(list), do: [ 1, 2, 3, 4, 5, 6, 7, 8, 9 ] -- list
  def possibilities(list, { :cell, row: row, col: col }) do
  end
  def possibilities(list, {:row, index} ) do
    possibilities(row(list,index))
  end
  def possibilities(list, {:column, index} ) do
    possibilities(column(list,index))
  end
  def possibilities(list, {:block, index} ) do
    possibilities(block(list,index))
  end
  def possibilities(list, { :cell, row: row, col: col }

end
