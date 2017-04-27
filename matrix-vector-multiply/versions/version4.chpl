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
const vectorReplicated = {0..#dimension} dmapped ReplicatedDist();
const vectorCyclic = matrixCyclic[.., 0];
var B : [vectorReplicated] int;
var B_cyclicreplicated : [vectorCyclicReplicated] int;
var C : [vectorCyclic] int;

forall a in A do a = 1;
forall b in B do b = 1;
forall b in B_cyclicreplicated do b = 1;

startVdebug("replicated_by_hand");

forall (i, c) in zip(vectorCyclic, C) {
    for (a, j) in zip(A(i, ..), 0..#dimension) {
        c += a * B_cyclicreplicated(here.id, j);
    }
}

stopVdebug();

startVdebug("replicated");

forall (i, c) in zip(vectorCyclic, C) {
    for (a, j) in zip(A(i, ..), 0..#dimension) {
        c += a * B(j);
    }
}

stopVdebug();

startVdebug("localSlice_replicated_by_hand");

forall (i, c) in zip(vectorCyclic, C) {
    for (a, j) in zip(A.localSlice(i..i, ..), 0..#dimension) {
        c += a * B_cyclicreplicated(here.id, j);
    }
}

stopVdebug();

startVdebug("localSlice_replicated");

forall (i, c) in zip(vectorCyclic, C) {
    for (a, j) in zip(A.localSlice(i..i, ..), 0..#dimension) {
        c += a * B(j);
    }
}

stopVdebug();

writeln(C);
