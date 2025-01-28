function f(n) {
    return n < 3
         ? n
         : f(n - 1) + 2 * f(n - 2) + 3 * f(n - 3);
}

function f2(n) {
    function f2_iter(n3, n2, n1, i) {
        return i === 0
             ? n1
             : f2_iter(n2, n1, n1 + 2 * n2 + 3 * n3, i - 1);
    }

    return n < 3
         ? n
         : f2_iter(0, 1, 2, n - 2);
}

/// ==========================================
function test() {
    for (let i = 0; i < 10; ++i) {
        console.log(f(i) === f2(i));
    }
}

test();
