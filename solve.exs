Code.load_file("sudoku.exs", __DIR__)


defmodule Solver do
  def solve([first_map|other_maps]) do
    IO.inspect length(other_maps)
    if Sudoku.invalid?(first_map) do
      solve(other_maps)
    else
      solutions = Sudoku.fill_cell(first_map)
      if Sudoku.unsolved?(hd(solutions)) do
        solve(solutions ++ other_maps)
      else
        solve(hd(solutions), true)
      end
    end
  end
  def solve(list, _solved) do
    IO.puts "solution found" 
    IO.puts Sudoku.to_s(list)
  end
end

{:ok, file} = File.read hd(System.argv)
sudoku_map = [Sudoku.to_board(file) |> Sudoku.to_map]
Solver.solve(sudoku_map)
