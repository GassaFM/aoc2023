import std;

immutable int dirs = 4;
immutable int [dirs] dRow = [-1,  0, +1,  0];
immutable int [dirs] dCol = [ 0, +1,  0, -1];
immutable string [dirs] [dirs] dTrans = [
    [`.|`, `/-`,   ``, `\-`],
    [`/|`, `.-`, `\|`,   ``],
    [  ``, `\-`, `.|`, `/-`],
    [`\|`,   ``, `/|`, `.-`],
];

void main () {
	auto a = stdin.byLineCopy.array;
	auto rows = a.length.to !(int);
	auto cols = a.front.length.to !(int);
	auto v = new bool [dirs] [] [] (rows, cols);

	void go (int row, int col, int dir) {
		if (row < 0 || rows <= row || col < 0 || cols <= col || v[row][col][dir])
			return;
		v[row][col][dir] = true;
		foreach (next; 0..dirs)
			if (dTrans[dir][next].canFind (a[row][col]))
				go (row + dRow[next], col + dCol[next], next);
	}

	int solve (int row, int col, int dir) {
		foreach (ref w; v)
			foreach (ref x; w)
				x[] = false;
		go (row, col, dir);
		return v.map !(w => w.map !(x => x[].any).sum).sum;
	}

	int res = 0;
	foreach (row; 0..rows)
		foreach (col; 0..cols) {
			if (row == 0)
				res = max (res, solve (row, col, 2));
			if (row == rows - 1)
				res = max (res, solve (row, col, 0));
			if (col == 0)
				res = max (res, solve (row, col, 1));
			if (col == cols - 1)
				res = max (res, solve (row, col, 3));
		}
	writeln (res);
}
