// Matrix Vector Multiply
// \mat(A) \times B = C

use ReplicatedDist;
use CyclicDist;
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
const vectorCyclicReplicated = {0..#numLocales, 0..#dimension} dmapped Cyclic(startIdx = (0, 0), targetLocales = localeGrid);
const vectorCyclic = matrixCyclic[.., 0];
var B : [vectorCyclicReplicated] int;
var C : [vectorCyclic] int;

forall a in A do a = 1;
forall b in B do b = 1;

startVdebug("vis");

forall (i, c) in zip(vectorCyclic, C) {
    for (a, j) in zip(A.localSlice(i..i, ..), 0..#dimension) {
        c += a * B(here.id, j);
    }
}

stopVdebug();

writeln(C);
