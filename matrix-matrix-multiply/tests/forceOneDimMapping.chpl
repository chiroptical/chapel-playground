use BlockDist;

// Run on more that 1 task per locale
config const tasksPerLocale: int = 1;

// Config consts for dimensionality
config const dimension: int = 5;

// Create a 1-d block mapping
var localeShape = {0..#numLocales, 0..0};
var locale1d: [localeShape] locale = reshape(Locales, localeShape);
const space = {0..#dimension, 0..#dimension};
const matrixBlock: domain(2) dmapped Block(boundingBox=space, targetLocales=locale1d) = space;
var A : [matrixBlock] int;
[a in A] a = a.locale.id;
writeln(A);
