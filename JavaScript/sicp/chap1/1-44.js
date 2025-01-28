function inc(x) {
    return x + 1;
}

function square(x) {
    return x * x;
}

function average3(x, y, z) {
    return (x + y + z) / 3;
}

// 1-42
function compose(f, g) {
    return x => f(g(x));
}

// 1-43
function repeat(f, t) {
    return t === 1
         ? f
         : compose(f, repeat(f, t - 1));
}

// 1-41
function fdouble(f) {
    return compose(f, f);
}

// 1-44
const dx = 0.00001;
function smooth(f) {
    return x => average3(f(x - dx), f(x), f(x + dx));
}

function hypersmooth(f, i) {
    return i === 0
         ? f
         : repeat(smooth, i)(f);
}

function test() {
    console.log(fdouble(fdouble(fdouble))(inc)(5));
    console.log(compose(square, inc)(6));
    console.log(repeat(square, 2)(5));
    console.log(hypersmooth(x => x % 3, 0)(3));
    console.log(hypersmooth(x => x % 3, 1)(3));
    console.log(hypersmooth(x => x % 3, 2)(3));
    console.log(hypersmooth(x => x % 3, 5)(3));
}

test();

