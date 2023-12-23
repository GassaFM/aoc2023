import std;

immutable int dirs = 4;
immutable int  [dirs] dRow  = [ -1,   0,  +1,   0];
immutable int  [dirs] dCol  = [  0,  +1,   0,  -1];
immutable char [dirs] dName = ['^', '>', 'v', '<'];

void main () {
	auto a = stdin.byLineCopy.array;
	auto rows = a.length.to !(int);
	auto cols = a.front.length.to !(int);

	auto d = new int [] [] [] (rows, cols, dirs);
	alias Coord = Tuple !(int, q{row}, int, q{col}, int, q{dir});
	Coord [] q;

	void add (int row, int col, int dir, int dist) {
		d[row][col][dir] = dist;
		q ~= Coord (row, col, dir);
	}

	enforce (a[0][1] != '#');
	add (0, 1, 2, 0);

	while (!q.empty)
	{
		int row, col, prev;
		AliasSeq !(row, col, prev) = q.front;
		q.popFront ();
		q.assumeSafeAppend ();
		auto cur = d[row][col][prev];
		auto must = dName[].countUntil (a[row][col]);
		foreach (dir; 0..dirs) {
			if ((dir ^ prev) == 2 || (must >= 0 && dir != must))
				continue;
			auto nRow = row + dRow[dir];
			auto nCol = col + dCol[dir];
			if (0 <= nRow && nRow < rows &&
			    0 <= nCol && nCol < cols &&
			    a[nRow][nCol] != '#') {
				add (nRow, nCol, dir, cur + 1);
			}
		}
	}

	writeln (d[rows - 1][cols - 2][].maxElement);
}
