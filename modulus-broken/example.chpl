proc mod(a: int, b: int): int {
  var r = a % b;
  if (r < 0) {
    return r + b;
  }
  else {
    return r;
  }
}

writeln(-1 % 3);
writeln(mod(-1, 3));
