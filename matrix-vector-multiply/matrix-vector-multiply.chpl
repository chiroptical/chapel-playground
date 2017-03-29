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
const MatrixDomain : domain(2) dmapped BlockCyclic(startIdx = MatrixSpace.low, blocksize = (1, dimension)) = MatrixSpace;

var A : [MatrixDomain] int;

// VectorDomain
// -> B is replicated across locales
// -> C is reduced, but BlockCylic similar to the MatrixDomain
const VectorSpace = {0..#dimension};
const VectorReplicatedDomain : domain(1) dmapped ReplicatedDist() = VectorSpace;
const VectorCyclicDomain : domain(1) dmapped BlockCyclic(startIdx = VectorSpace.low, blocksize = 1) = VectorSpace;

var B : [VectorReplicatedDomain] int;
var C : [VectorCyclicDomain] int;

// Initialize variables
forall a in A do a = 1;
forall b in B do b = 1;

startVdebug("chplvis");

// Distribute tasks 
forall (i, c) in zip({0..#dimension}, C(..)) {
    forall (j, a) in zip({0..#dimension}, A(i, ..)) with ( + reduce c ) {
        c += a * B(j);
    }
}

stopVdebug();

// Print results
forall c in C do writeln(c);
