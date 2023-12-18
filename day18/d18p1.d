import std;

immutable int dirs = 4;
immutable int [dirs] dRow = [-1,  0, +1,  0];
immutable int [dirs] dCol = [ 0, +1,  0, -1];
immutable char [dirs] dNames = ['U', 'R', 'D', 'L'];

void main () {
	long area = 0, border = 0, row = 0, col = 0, pRow = row, pCol = col;
	foreach (t; stdin.byLineCopy.map !(split)) {
		auto dir = dNames[].countUntil (t[0][0]).to !(int);
		auto len = t[1].to !(long);
		row += dRow[dir] * len;
		col += dCol[dir] * len;
		area += (pRow - row) * 1L * (pCol + col);
		border += len;
		pRow = row;
		pCol = col;
	}
	area += (pRow - row) * (pCol + col);
	writeln (border / 2 + abs (area) / 2 + 1);
}
