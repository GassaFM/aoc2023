import std;

alias Rule = Tuple !(string, q{cat}, string, q{op}, int, q{value}, string, q{dest});

Rule toRule (string s) {
	if (!s.canFind (":"))
		return Rule ("", "", 0, s);
	Rule res;
	auto t0 = s.findSplit (":");
	res.dest = t0[2];
	foreach (op; ["<", ">"])
		if (t0[0].canFind (op)) {
			auto t1 = t0[0].findSplit (op);
			res.cat = t1[0];
			res.op = t1[1];
			res.value = t1[2].to !(int);
			return res;
		}
	assert (false);
}

void main () {
	string s;
	Rule [] [string] rules;
	while ((s = readln.strip) != "") {
		auto t0 = s.split ('{');
		auto name = t0[0];
		auto t1 = t0[1].stripRight ('}').split (',');
		rules[name] ~= t1.map !(toRule).array;
	}

	alias Segment = Tuple !(int, q{lo}, int, q{hi});
	long res = 0;

	void recur (string cursor, Segment [string] pos) {
		if (cursor == "R")
			return;
		if (cursor == "A") {
			long cur = 1;
			foreach (k, v; pos)
				cur *= v.hi - v.lo + 1;
			res += cur;
			return;
		}

		foreach (rule; rules[cursor])
		{
			if (rule.op == "") {
				recur (rule.dest, pos);
				break;
			}

			auto next = pos.dup;
			if (rule.op == "<") {
				next[rule.cat].hi = min (next[rule.cat].hi, rule.value - 1);
				pos[rule.cat].lo = max (pos[rule.cat].lo, rule.value);
			}
			else if (rule.op == ">") {
				next[rule.cat].lo = max (next[rule.cat].lo, rule.value + 1);
				pos[rule.cat].hi = min (pos[rule.cat].hi, rule.value);
			}
			else
				assert (false);

			if (next[rule.cat].lo <= next[rule.cat].hi)
				recur (rule.dest, next);
			if (pos[rule.cat].lo > pos[rule.cat].hi)
				break;
		}
	}

	Segment [string] pos;
	pos["x"] = Segment (1, 4000);
	pos["m"] = Segment (1, 4000);
	pos["a"] = Segment (1, 4000);
	pos["s"] = Segment (1, 4000);
	recur ("in", pos);
	writeln (res);
}
