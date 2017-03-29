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

startVdebug("vis");

// Distribute tasks 
forall i in {0..#dimension} {
    var inner : int = 0;
    forall (j, a) in zip({0..#dimension}, A(i, 0..#dimension)) with ( + reduce inner ) {
        inner += a * B(j);
    }
    C(i) = inner;
}

stopVdebug();

// Print results
forall c in C do writeln(c);
