// Matrix Matrix Multiply
// \mat(A) \times \mat(B) = \mat(C)

use BlockDist;

// By default, only use one task per locale
config const tasksPerLocale: int = 1;

// The initial dimension as a config const
config const dimension: int = 15;

// Matrix domain, block distributed to locales
const space = {0..#dimension, 0..#dimension};
const matrixBlock: domain(2) dmapped Block(boundingBox=space) = space;
var A : [matrixBlock] int;
var B : [matrixBlock] int;
var C : [matrixBlock] int;

//forall a in A do a = a.locale.id;
//forall b in B do b = b.locale.id;
