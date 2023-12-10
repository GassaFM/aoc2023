import std;

immutable int dirs = 4;
immutable int [dirs] dRow = [-1,  0, +1,  0];
immutable int [dirs] dCol = [ 0, +1,  0, -1];
immutable string [dirs] dNames = ["SLJ|", "SLF-", "S7F|", "S7J-"];

void main () {
	auto a = stdin.byLineCopy.array;
	auto rows = a.length.to !(int);
	auto cols = a[0].length.to !(int);
	auto vis = new bool [] [] (rows, cols);

	int area = 0, pRow, pCol;

	void go (int row, int col) {
		if (vis[row][col])
			return;
		vis[row][col] = true;
		area += (pRow - row) * (pCol + col);
		pRow = row;
		pCol = col;
		foreach (dir; 0..dirs)
			if (dNames[dir].canFind (a[row][col])) {
				auto nRow = row + dRow[dir];
				auto nCol = col + dCol[dir];
				if (0 <= nRow && nRow < rows &&
				    0 <= nCol && nCol < cols &&
				    dNames[dir ^ 2].canFind (a[nRow][nCol]))
					go (nRow, nCol);
	        	}
	}

	foreach (row; 0..rows)
		foreach (col; 0..cols)
			if (a[row][col] == 'S') {
				pRow = row;
				pCol = col;
				go (row, col);
				area += (pRow - row) * (pCol + col);
				auto border = vis.map !(sum).sum;
				writeln (abs (area) / 2 - border / 2 + 1);
			}
}
