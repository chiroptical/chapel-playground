// Matrix Vector Multiply
// \mat(A) \times B = C

use CyclicDist;
use ReplicatedDist;
use VisualDebug;

config const tasksPerLocale : int = 1;

// The problem dimensions
config const dimension : int = 10;

// Create a grid for the Locales, makes Cyclic dmap easier
const localeGrid = reshape(Locales, {0..#numLocales, 0..0});

// Matrix, rows distributed to locales using cyclic distribution
const matrixCyclic = {0..#dimension, 0..#dimension} dmapped Cyclic(startIdx = (0, 0), targetLocales = localeGrid);
var A : [matrixCyclic] int;

// VectorDomain
// -> B is replicated across locales
// -> C is reduced, with cylic distribution similar to matrixCyclic
const vectorReplicated = {0..#dimension} dmapped ReplicatedDist();
const vectorCyclic = matrixCyclic[.., 0];
var B : [vectorReplicated] int;
var C : [vectorCyclic] int;

//forall a in A do a = a.locale.id;
//forall b in B do b = b.locale.id;
//forall c in C do c = c.locale.id;
//
//writeln(A);
//writeln();
//writeln(B);
//writeln();
//writeln(C);

// Initialize Vectors
for a in A do a = 1;
for b in B do b = 1;

// Start the chplvis counting
startVdebug("chplvis");

// The main loop
forall ((i,), c) in zip(vectorCyclic, C) {
    forall (a, j) in zip(A(i, ..), {0..#dimension}) with (+ reduce c) {
        c += a * B(j);
    }
}

// Stop chplvis counting
stopVdebug();

// Print the results
writeln(C);
