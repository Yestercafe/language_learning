function is_even(n) {
    return n % 2 === 0;
}

function fast_times(a, b) {
    function double(x) {
        return x + x;
    }
    function halve(x) {
        return x / 2;
    }

    return b == 1
         ? a
         : is_even(b)
         ? double(fast_times(a, halve(b)))
         : a + fast_times(a, b - 1);
}

/// ======================================
function test() {
    for (let a = 1; a < 10; ++a) {
        for (let b = 1; b < 10; ++b) {
            console.log(a * b == fast_times(a, b));
        }
    }
}

test();

