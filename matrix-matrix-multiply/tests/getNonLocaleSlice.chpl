// Our distribution
use BlockDist;

// Modulus isn't implemented correctly for negative numbers
proc mod(a: int, b: int): int {
  var r = a % b;
  if (r < 0) {
    return r + b;
  }
  else {
    return r;
  }
}

// By default, only use one task per locale
config const tasksPerLocale: int = 1;

// The initial dimension as a config const
config const dimension: int = 15;

// Matrix domain, block dist to locales
const space = {0..#dimension, 0..#dimension};
const matrixBlock: domain(2) dmapped Block(boundingBox=space) = space;
var A: [matrixBlock] int;

// Get the shape of the distribution
var localeMatrix: [A.targetLocales().domain] int = A.targetLocales().id;

// Initialize
[a in A] a = a.locale.id;

// Get the height and width of the localeMatrix, can't use zero index with tuples
const height = localeMatrix.shape(1);
const width = localeMatrix.shape(2);

// On each locale, print the subdomain values
for loc in Locales {
    on loc {
        // Hop row down/up, need firstInRow
        var firstInRow = (here.id / width): int * width;
        var rowDown = mod(here.id - 1, width) + firstInRow;
        var rowUp = mod(here.id + 1, width) + firstInRow;

        // Hop column down/ip, need current column
        var col = here.id % width;
        var colDown = width * mod(((here.id / width): int + 1), 3) + col;
        var colUp = width * mod(((here.id / width): int - 1), 3) + col;

        // local domains to store slices
        var sliceRowDown: domain(2);
        var sliceRowUp: domain(2);
        var sliceColDown: domain(2);
        var sliceColUp: domain(2);

        // define the slice domains
        on Locales[rowDown] {
          sliceRowDown = A.localSubdomain();
        }
        on Locales[rowUp] {
          sliceRowUp = A.localSubdomain();
        }
        on Locales[colDown] {
          sliceColDown = A.localSubdomain();
        }
        on Locales[colUp] {
          sliceColUp = A.localSubdomain();
        }
  
        // Define the local distributions
        var localRowDown: [sliceRowDown] int = A[sliceRowDown];
        var localRowUp: [sliceRowUp] int = A[sliceRowUp];
        var localColDown: [sliceColDown] int = A[sliceColDown];
        var localColUp: [sliceColUp] int = A[sliceColUp];

        // Are we getting rowDown slice?
        writeln(here.id);
        writeln(localRowDown.locale.id);
        writeln(localRowDown);
        writeln(localRowUp);
        writeln(localColDown);
        writeln(localColUp);
        writeln();
    }
}
