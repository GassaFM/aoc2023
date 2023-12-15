import std;
alias h=s=>fold!"(a+b)*17"(s,0)&255;
void main () {
	string [] [256] v;
	int [string] [256] s;
	foreach (c; readln.strip.split(",")) {
		string coord, op, value;
		AliasSeq !(coord, op, value) = findSplit!"a<b" (c, "a");
		auto p = h (coord);
		if (!v[p].canFind (coord)) v[p] ~= coord;
		auto q = v[p].countUntil (coord);
		if (op == "=") s[p][coord] = value.to!int;
		else v[p] = v[p][0..q] ~ v[p][q + 1..$];
	}
	int res = 0;
	foreach (p; 0..256)
		foreach (q, coord; v[p])
			res += (p + 1) * (q + 1) * s[p][coord];
	writeln (res);
}
