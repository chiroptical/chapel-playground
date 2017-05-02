use BlockDist;
config const dimension: int = 5;
const space = {0..#dimension, 0..#dimension};
const matrixBlock: domain(2) dmapped Block(boundingBox=space) = space;
var A : [matrixBlock] int;
[a in A] a = a.locale.id;
writeln(A);
