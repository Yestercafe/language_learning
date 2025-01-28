function is_even(n) {
    return n % 2 === 0;
}

function fast_expt(b, n) {
    function fast_expt_iter(prod, k, i) {
        return i === 0
             ? prod
             : is_even(i)
             ? fast_expt_iter(prod, k * k, i / 2)
             : fast_expt_iter(prod * k, k, i - 1);
    }

    return fast_expt_iter(1, b, n);
}

function fast_expt_recursive(b, n) {
    function square(a) {
        return a * a;
    }

    return n == 0
         ? 1
         : is_even(n)
         ? square(fast_expt_recursive(b, n / 2))
         : b * fast_expt_recursive(b, n - 1);
}

/// ==========================================
function test() {
    for (let n = 2; n < 10; ++n) {
        let c = 1;
        for (let i = 0; i < n; ++i) {
            c *= 3;
        }
        console.log(c === fast_expt(3, n));
        console.log(fast_expt_recursive(3, n) === fast_expt(3, n));
    }
}

test();

