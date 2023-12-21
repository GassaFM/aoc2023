import std;

immutable int dirs = 4;
immutable int [dirs] dRow = [-1,  0, +1,  0];
immutable int [dirs] dCol = [ 0, +1,  0, -1];
immutable int infinity = int.max / 4;

void main () {
	auto a = stdin.byLineCopy.array;
	auto rows = a.length.to !(int);
	auto cols = a.front.length.to !(int);

	int tRow, tCol;
	foreach (row; 0..rows)
		foreach (col; 0..cols)
			if (a[row][col] == 'S') {
				tRow = row;
				tCol = col;
			}

	long steps = 26501365;
	int b0 = steps % 2;
	auto size = rows;
	enforce (size == cols);
	enforce (steps % size == size / 2);
	enforce (steps >= size);

	int [] [] solve (int sRow, int sCol) {
		alias Coord = Tuple !(int, q{row}, int, q{col});
		Coord [] q;
		auto d = new int [] [] (rows, cols);
		foreach (row; 0..rows)
			foreach (col; 0..cols)
				d[row][col] = infinity;

		void add (int row, int col, int dist) {
			d[row][col] = dist;
			q ~= Coord (row, col);
		}

		add (sRow, sCol, 0);
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
		return d;
	}

	int half = size / 2;
	int [] [] [3] [3] d;
	foreach (u; 0..3)
		foreach (v; 0..3) {
			auto cRow = half * u;
			auto cCol = half * v;
			d[u][v] = solve (cRow, cCol);
		}
	enforce (d[1][1].all !(line => line.all !(x =>
	    x == infinity || x < size)));

	long [2] r;
	foreach (b; 0..2)
		r[b] = d[1][1].map !(line => line.count !(x =>
		    x < infinity && x % 2 == b)).sum (0L);
	long res = 0;
	long full = steps / size;
	res += r[b0];
	for (int i = 1; i < full; i++)
		res += r[(i & 1) ^ b0] * i * 4;

	long go (int u, int v, long dist) {
		auto b = dist % 2;
		return d[u][v].map !(line => line.count !(x =>
		    x <= dist && x % 2 == b)).sum (0L);
	}

	long corners = 0;
	corners += go (0, 1, size - 1);
	corners += go (1, 0, size - 1);
	corners += go (2, 1, size - 1);
	corners += go (1, 2, size - 1);

	long edgesLow = 0;
	edgesLow += go (0, 0, half - 1);
	edgesLow += go (0, 2, half - 1);
	edgesLow += go (2, 0, half - 1);
	edgesLow += go (2, 2, half - 1);
	edgesLow *= full - 0;

	long edgesHigh = 0;
	edgesHigh += go (0, 0, half + size - 1);
	edgesHigh += go (0, 2, half + size - 1);
	edgesHigh += go (2, 0, half + size - 1);
	edgesHigh += go (2, 2, half + size - 1);
	edgesHigh *= full - 1;

	res += corners + edgesLow + edgesHigh;
	writeln (res);
}
