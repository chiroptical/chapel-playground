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
var B : [vectorReplicated] int;

// Initialize
forall a in A do a = 1;

startVdebug("chplvis");

forall (i, j) in matrixCyclic {
    A(i, j) *= B(j);   
}

stopVdebug();
