import std;

immutable int dirs = 4;
immutable int [dirs] dRow = [-1,  0, +1,  0];
immutable int [dirs] dCol = [ 0, +1,  0, -1];
immutable int infinity = int.max / 4;

void main () {
	auto a = stdin.byLineCopy.array;
	auto rows = a.length.to !(int);
	auto cols = a.front.length.to !(int);

	auto d = new int [] [] (rows, cols);
	alias Coord = Tuple !(int, q{row}, int, q{col});
	Coord [] q;

	void add (int row, int col, int dist) {
		d[row][col] = dist;
		q ~= Coord (row, col);
	}

	foreach (row; 0..rows)
		foreach (col; 0..cols) {
			d[row][col] = infinity;
			if (a[row][col] == 'S')
				add (row, col, 0);
		}

	while (!q.empty) {
		int row, col;
		AliasSeq !(row, col) = q.front;
		q.popFront ();
		q.assumeSafeAppend ();
		auto cur = d[row][col];
		foreach (dir; 0..dirs) {
			auto nRow = row + dRow[dir];
			auto nCol = col + dCol[dir];
			if (0 <= nRow && nRow < rows &&
			    0 <= nCol && nCol < cols &&
			    a[nRow][nCol] != '#' &&
			    d[nRow][nCol] == infinity)
				add (nRow, nCol, cur + 1);
		}
	}
	int steps = 64;
	writeln (d.map !(line => line.count !(x =>
	    x <= steps && x % 2 == steps % 2)).sum);
}
