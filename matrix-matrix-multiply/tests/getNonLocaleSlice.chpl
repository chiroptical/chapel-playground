use BlockDist;

// By default, only use one task per locale
config const tasksPerLocale: int = 1;

// The initial dimension as a config const
config const dimension: int = 15;

// Matrix domain, block distributed to locales
const space = {0..#dimension, 0..#dimension};
const matrixBlock: domain(2) dmapped Block(boundingBox=space) = space;
var A : [matrixBlock] int;

// forall set to locale.id
[a in A] a = a.locale.id;

const width = sqrt(numLocales): int;

// On each locale, print the subdomain values
for loc in Locales {
    var nonLocalSlice: domain(1);
    on loc {
        var col = here.id % width;
        var row = here.id / width: int;
        writeln(here.id, ' ', row, ' ', col);
    }
}
