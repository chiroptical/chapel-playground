// Need BlockDist module to use Block distribution mapping
use BlockDist;

// Some config constants for running the problem
config const tasksPerLocale : int = 1;
config const numberGridPoints : int = 10;

// The Grid and Domain specification
const Grid = {1..numberGridPoints};
const Domain: domain(1) dmapped Block(boundingBox = Grid) = Grid;

// Our approximation procedure
proc approx(a: real) return 4.0 / (1.0 + a ** 2);

// The separation of grid points and the sum which will catch a reduce
var dGrid : real = 1.0 / numberGridPoints;
var sum : real = 0.0;

// forall values in the domain calculation the valueOnGrid and approx of that value
forall d in Domain with (+ reduce sum) {
    var valueOnGrid : real = dGrid * (d + 0.5);
    sum += approx(valueOnGrid);
}

// Print out Pi
writeln("Pi is approximately: ", sum * dGrid);

writeln(here.maxTaskPar);                // per-locale parallelism
writeln(here.numPUs(accessible=true));   // # cores we have access to
writeln(here.numPUs(accessible=false));  // # cores on the locale
