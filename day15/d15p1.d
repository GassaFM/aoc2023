import std;
alias h=s=>fold!"(a+b)*17"(s,0)&255;
void main(){readln.strip.split(",").map!h.sum.writeln;}
