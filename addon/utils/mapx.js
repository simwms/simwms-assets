import Ember from 'ember';

const {A: a, get, getWithDefault} = Ember;

function map2 (xss, f, output=a()) {
  if (get(xss, "length") > 1) {
    const [x1, ...xs] = xss;
    const [x2] = xs;
    output.pushObject(f(x1, x2));
    return map2(xs, f, output);
  } else {
    output.pushObjects(output.slice(-1));
    return output;
  }
}

function access(array, ind) {
  if (ind < 0) {
    return null;
  }
  if (ind >= get(array, "length")) {
    return null;
  }
  return a(array).objectAt(ind);
}

// A map with a lookahead and a lookbehind
function map3 (xss, f) {
  var k = 0;
  var output = a();
  const length = getWithDefault(xss, "length", 0);
  while (k < length) {
    let lookbehind = access(xss, k-1);
    let currentval = access(xss, k);
    let lookahead = access(xss, k+1);
    output.pushObject(f(lookbehind, currentval, lookahead));
    k++;
  }
  return output;
}

export {map2, map3};