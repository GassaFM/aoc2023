import std;

immutable int dirs = 4;
immutable int  [dirs] dRow  = [ -1,   0,  +1,   0];
immutable int  [dirs] dCol  = [  0,  +1,   0,  -1];
immutable char [dirs] dName = ['^', '>', 'v', '<'];

void main () {
	auto a = stdin.byLineCopy.array;
	auto rows = a.length.to !(int);
	auto cols = a.front.length.to !(int);

	alias Square = Tuple !(int, q{row}, int, q{col});
	int [Square] special;
	Square [] specialList;
	int n = 0;

	void addToList (int row, int col) {
		auto cur = Square (row, col);
		specialList ~= cur;
		special[cur] = n;
		n += 1;
	}

	addToList (0, 1);
	addToList (rows - 1, cols - 2);
	foreach (row; 0..rows)
		foreach (col; 0..cols) {
			if (a[row][col] == '#')
				continue;
			int num = 0;
			foreach (dir; 0..dirs) {
				auto nRow = row + dRow[dir];
				auto nCol = col + dCol[dir];
				if (0 <= nRow && nRow < rows &&
				    0 <= nCol && nCol < cols &&
				    dName[].canFind (a[nRow][nCol]))
					num += 1;
			}
			if (num > 1)
				addToList (row, col);
		}
	writeln ("n = ", n);

	alias Edge = Tuple !(int, q{v}, int, q{d});
	auto adj = new Edge [] [n];
	foreach (i; 0..n) {
		auto d = new int [] [] (rows, cols);
		Square [] q;

		void add (int row, int col, int dist) {
			d[row][col] = dist;
			q ~= Square (row, col);
		}

		add (specialList[i].row, specialList[i].col, 1);
		while (!q.empty) {
			auto cur = q.front;
			q.popFront ();
			q.assumeSafeAppend ();
			auto dist = d[cur.row][cur.col];
			if (cur in special && special[cur] != i) {
				adj[i] ~= Edge (special[cur], dist - 1);
				continue;
			}
			foreach (dir; 0..dirs) {
				auto nRow = cur.row + dRow[dir];
				auto nCol = cur.col + dCol[dir];
				if (0 <= nRow && nRow < rows &&
				    0 <= nCol && nCol < cols &&
				    a[nRow][nCol] != '#' &&
				    d[nRow][nCol] == 0)
					add (nRow, nCol, dist + 1);
			}
		}
	}

	foreach (i; 0..n) {
		write (i, ":");
		foreach (e; adj[i])
			write (" (", e.v, " ", e.d, ")");
		writeln;
	}

	int res = 0;
	auto used = new bool [n];

	void recur (int u, int d) {
		if (u == 1) {
			res = max (res, d);
			return;
		}
		used[u] = true;
		foreach (e; adj[u])
			if (!used[e.v])
				recur (e.v, d + e.d);
		used[u] = false;
	}

	recur (0, 0);
	writeln (res);
}
