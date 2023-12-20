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

	long [2] v;
	foreach (step; 0..1000) {
		alias Record = Tuple !(string, string, int);
		Record [] q;

		void push (string name, string cand, int value) {
			q ~= Record (name, cand, value);
			v[value] += 1;
		}

		push ("button", "broadcaster", 0);
		while (!q.empty) {
			string prev, name;
			int value;
			AliasSeq !(prev, name, value) = q.front;
			q.popFront ();
			q.assumeSafeAppend ();
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
	}
	writeln (v[].fold !(q{a * b}));
}
