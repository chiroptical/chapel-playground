// Matrix Vector Multiply
// \mat(A) \times B = C

use BlockCycDist;
use ReplicatedDist;
use VisualDebug;

config const tasksPerLocale : int = 1;

// The problem dimensions
config const dimension : int = 10;

// MatrixDomain, rows distributed to locales using BlockCyclic Distribution
const MatrixSpace = {0..#dimension, 0..#dimension};
const MatrixDomain : domain(2) dmapped BlockCyclic(startIdx=MatrixSpace.low, blocksize=(1, dimension)) = MatrixSpace;

var A : [MatrixDomain] int;

// VectorDomain
// -> B is replicated across locales
// -> C is reduced only needs to exist on first locale
const VectorSpace = {0..#dimension};
const VectorDomain : domain(1) dmapped ReplicatedDist() = VectorSpace;

var B : [VectorDomain] int;
var C : [VectorSpace] int;

// Initialize variables
forall a in A do a = 1;
forall b in B do b = 1;

forall c in C {
    c = c.locale.id;
}

writeln(C);
