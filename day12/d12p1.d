import std;

void main () {
	long res = 0;
	foreach (ref b; stdin.byLineCopy) {
		auto t = b.split;
		auto s = t[0];
		s ~= '.';
		auto a = t[1].strip.split (",").map !(to !(int)).array;
		auto n = s.length.to !(int);
		auto k = a.length.to !(int);
		a ~= n + 1;

		auto f = new long [] [] [] (n + 1, k + 2, n + 2);
		f[0][0][0] = 1;
		foreach (i; 0..n)
			foreach (j; 0..k + 1)
				foreach (p; 0..n + 1) {
					auto cur = f[i][j][p];
					if (!cur)
						continue;
					if (s[i] == '.' || s[i] == '?')
						if (p == 0 || p == a[j - 1])
							f[i + 1][j][0] += cur;
					if (s[i] == '#' || s[i] == '?')
						f[i + 1][j + !p][p + 1] += cur;
				}
		res += f[n][k][0];
	}
	writeln (res);
}
