defmodule Sudoku do

  def create( list ), do: ( list )

  def row(list, number) do 
    {:ok, rv } = Enum.fetch( list,number )
    rv
  end

  def column(list, number) do 
    Enum.map( list, fn(row) ->  Enum.fetch!(row,number)  end)
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

  def possibilities(list, {:row, index} ) do
    [ 1, 2, 3, 4, 5, 6, 7, 8, 9 ] -- 
    Sudoku.row(list,index)
  end

end
