import std;

enum Type {none, flip, conj};

void main () {
	string [] [string] dst;
	string [] [string] src;
	int [string] [string] mem;
	int [string] state;
	Type [string] type;
	foreach (ref line; stdin.byLineCopy) {
		auto curType = Type.none;
		if (line[0] == '%') {
			curType = Type.flip;
			line = line[1..$];
		}
		if (line[0] == '&') {
			curType = Type.conj;
			line = line[1..$];
		}
		auto temp = line.findSplit (" -> ");
		auto name = temp[0];
		auto right = temp[2].split (", ");

		type[name] = curType;
		foreach (ref cand; right) {
			dst[name] ~= cand;
			src[cand] ~= name;
			mem[cand][name] = 0;
		}
		state[name] = 0;
	}

	long [] [string] num;
	foreach (step; 0..100000) {
		alias Record = Tuple !(string, string, int);
		Record [] q;

		void push (string name, string cand, int value) {
			q ~= Record (name, cand, value);
		}

		int [string] curNum;
		push ("button", "broadcaster", 0);
		while (!q.empty) {
			string prev, name;
			int value;
			AliasSeq !(prev, name, value) = q.front;
			q.popFront ();
			q.assumeSafeAppend ();
			curNum[name] += 1;
			if (name !in type)
				continue;
			if (type[name] == Type.flip && value == 1)
				continue;
			if (type[name] == Type.flip && value == 0) {
				state[name] ^= 1;
				value = state[name];
			}
			if (type[name] == Type.conj) {
				mem[name][prev] = value;
				value = !all (mem[name].byValue);
			}
			foreach (cand; dst[name])
				push (name, cand, value);
		}
		foreach (name, _; type)
			num[name] ~= curNum.get (name, 0);
	}

	long go (string name) {
		auto x = num[name];
		for (int p = 1; ; p++)
			if (x[0..$ - p] == x[p..$]) {
				writeln (name, " ", p);
				return p;
			}
		assert (false);
	}

	long res = 1;
	foreach (name; ["ls", "nb", "vc", "vg"])
		res *= go (name);
	writeln (res);
}
