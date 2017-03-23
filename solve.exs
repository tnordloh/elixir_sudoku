Code.load_file("sudoku.exs", __DIR__)

{:ok, file} = File.read "sudoku_map.txt"

IO.puts(file)
sudoku_map = Sudoku.map(file)


defmodule Solver do
  def solve(list) do
    IO.puts("solving...")
    list = Sudoku.fill_cell(list)
    if Sudoku.unsolved?(list) do
      IO.puts Sudoku.to_s(list)
      solve(list)
    else
      solve(list, true)
    end
  end
  def solve(list, solved) do
    IO.puts Sudoku.to_s(list)
    IO.puts solved
  end
end

Solver.solve(sudoku_map)
