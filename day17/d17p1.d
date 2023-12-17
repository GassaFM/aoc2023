import std;

immutable int dirs = 4;
immutable int [dirs] dRow = [-1,  0, +1,  0];
immutable int [dirs] dCol = [ 0, +1,  0, -1];
immutable int maxTimes = 3;
immutable int maxHeat = 10;

void main () {
	auto a = stdin.byLineCopy.array;
	auto rows = a.length.to !(int);
	auto cols = a[0].length.to !(int);
	alias Coord = Tuple !(int, q{row}, int, q{col}, int, q{dir}, int, q{times});
	auto len = rows * cols * maxTimes * maxHeat;
	auto v = new bool [maxTimes] [dirs] [] [] (rows, cols);
	auto q = new Coord [] [len + maxHeat];
	foreach (dir; 0..dirs)
		q[0] ~= Coord (0, 0, dir, 0);
	foreach (step; 0..len)
		foreach (temp; q[step]) {
			int row, col, dir, times;
			AliasSeq !(row, col, dir, times) = temp;
			if (row == rows - 1 && col == cols - 1) {
				writeln (step);
				return;
			}
			foreach (nDir; 0..dirs) {
				auto nRow = row + dRow[nDir];
				auto nCol = col + dCol[nDir];
				auto nTimes = (dir == nDir) ? times + 1 : 0;
				if (nRow < 0 || rows <= nRow ||
				    nCol < 0 || cols <= nCol ||
				    (dir ^ nDir) == 2 ||
				    nTimes >= maxTimes ||
				    v[nRow][nCol][nDir][nTimes])
					continue;
				v[nRow][nCol][nDir][nTimes] = true;
				auto nStep = step + a[nRow][nCol] - '0';
				q[nStep] ~= Coord (nRow, nCol, nDir, nTimes);
			}
		}
}
