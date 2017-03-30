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
const matrix = {0..#dimension, 0..#dimension} dmapped Cyclic(startIdx = (0, 0), targetLocales = localeGrid);
var A : [matrix] int;

// VectorDomain
// -> B is replicated across locales
// -> C is reduced, with cylic distribution similar to matrix
const vectorReplicated = {0..#dimension} dmapped ReplicatedDist();
const vectorCyclic = matrix[.., 0];

var B : [vectorReplicated] int;
var C : [vectorCyclic] int;

for a in A do a = a.locale.id;
for b in B do b = b.locale.id;
for c in C do c = c.locale.id;

writeln(A);
writeln();
writeln(B);
writeln();
writeln(C);
