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

	long res = 0;
	while ((s = readln.strip) != "") {
		auto t0 = s.stripLeft ('{').stripRight ('}').split (',');
		int [string] curValues;
		long total = 0;
		foreach (ref c; t0) {
			auto t1 = c.findSplit ("=");
			auto name = t1[0];
			auto value = t1[2].to !(int);
			curValues[name] = value;
			total += value;
		}

		string cursor = "in";
		while (cursor != "A" && cursor != "R")
			foreach (rule; rules[cursor])
				if (rule.op == "" ||
				    (rule.op == "<" && curValues[rule.cat] < rule.value) ||
				    (rule.op == ">" && curValues[rule.cat] > rule.value)) {
					cursor = rule.dest;
					break;
				}
		if (cursor == "A")
			res += total;
	}
	writeln (res);
}
