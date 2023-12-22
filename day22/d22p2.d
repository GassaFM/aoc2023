import std;

void main () {
	alias Brick = Tuple
	    !(int, q{x1}, int, q{x2},
	      int, q{y1}, int, q{y2},
	      int, q{z1}, int, q{z2});
	Brick [] b;
	foreach (line; stdin.byLineCopy) {
		auto t = line.tr (",~", "  ").split.to !(int[]);
		b ~= Brick (min (t[0], t[3]), max (t[0], t[3]),
		            min (t[1], t[4]), max (t[1], t[4]),
		            min (t[2], t[5]), max (t[2], t[5]));
	}
	auto n = b.length.to !(int);

	bool inter2 (int i, int j) {
		return i != j &&
		    max (b[i].x1, b[j].x1) <= min (b[i].x2, b[j].x2) &&
		    max (b[i].y1, b[j].y1) <= min (b[i].y2, b[j].y2) &&
		    max (b[i].z1, b[j].z1) <= min (b[i].z2, b[j].z2);
	}

	bool inter (int i) {
		return n.iota.any !(j => inter2 (i, j));
	}

	bool changed;
	do {
		b.schwartzSort !(u => tuple (u.z1, u.x1, u.y1));
		changed = false;
		foreach (i; 0..n)
			while (b[i].z1 > 1) {
				b[i].z1 -= 1;
				if (inter (i)) {
					b[i].z1 += 1;
					break;
				}
				b[i].z2 -= 1;
				changed = true;
			}
	}
	while (changed);

	immutable int much = 1000;
	int res = 0;
	foreach (i; 0..n) {
		b[i].z2 -= much;
		scope (exit) {b[i].z2 += much;}
		foreach (j; i + 1..n)
			if (b[j].z1 > 1) {
				b[j].z1 -= 1;
				scope (exit) {b[j].z1 += 1;}
				if (!inter (j)) {
					b[j].z2 -= much;
					res += 1;
				}
			}
		foreach (j; i + 1..n)
			if (b[j].z2 < 0)
				b[j].z2 += much;
	}
	writeln (res);
}
