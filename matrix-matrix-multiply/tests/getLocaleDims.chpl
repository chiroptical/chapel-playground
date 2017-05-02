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

// On each locale, print the subdomain values
for loc in Locales {
    on loc {
        writeln(A(A.localSubdomain()));
        writeln();
    }
}
