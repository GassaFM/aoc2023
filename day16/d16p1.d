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

	go (0, 0, 1);
	writeln (v.map !(w => w.map !(x => x[].any).sum).sum);
}
