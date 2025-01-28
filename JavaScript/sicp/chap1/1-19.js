function is_even(n) {
    return n % 2 === 0;
}

function fib(n) {
    function fib_iter(a, b, p, q, count) {
        return count === 0
             ? b
             : is_even(count)
             ? fib_iter(a,
                        b,
                        p * p + q * q,
                        2 * p * q + q * q,
                        count / 2)
             : fib_iter(b * q + a * p + a * q,
                        b * p + a * q,
                        p,
                        q,
                        count - 1);
    }
    return fib_iter(1, 0, 0, 1, n);
}

/// =================================
function test() {
    for (let i = 2; i < 20; ++i) {
        console.log(fib(i));
    }
}

test();

