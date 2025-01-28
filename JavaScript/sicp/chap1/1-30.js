function sum(term, a, next, b) {
    function iter(a, result) {
        return a == b + 1
             ? result
             : iter(next(a), result + term(a));
    }
    return iter(a, 0);
}

/// ========================================
function test() {
    function identity(x) {
        return x;
    }
    function inc(x) {
        return x + 1;
    }
    console.log(sum(identity, 1, inc, 10));
}

test();

