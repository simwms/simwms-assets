import Ember from 'ember';

const {get, A: a} = Ember;

function equalNonTrivialLength(xs, ys) {
  if (get(xs, "length") > 0) {
    if (get(ys, "length") > 0) {
      if (get(ys, "length") === get(xs, "length")) {
        return true;
      }
    }
  }
  return false;
}

function zipWith (xss, yss, f, output=a()) {
  if (equalNonTrivialLength(xss, yss)) {
    const [x, ...xs] = xss;
    const [y, ...ys] = yss;
    output.pushObject(f(x,y));
    return zipWith(xs, ys, f, output);
  } else {
    return output;
  }
}

export default zipWith;