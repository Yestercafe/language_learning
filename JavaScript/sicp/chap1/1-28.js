function is_even(n) {
    return n % 2 == 0;
}

function square(x) {
    return x * x;
}

function expmod(base, exp, m) {
    return exp === 0
         ? 1
         : is_even(exp)
         ? square(expmod(base, exp / 2, m)) % m
         : (base * expmod(base, exp - 1, m)) % m;
}

function fermat_test(n) {
    function try_it(a) {
        return expmod(a, n, n) === a;
    }
    return try_it(1 + Math.floor(Math.random() * (n - 1)));
}

function fast_is_prime(n, times) {
    return times === 0
         ? true
         : fermat_test(n)
         ? fast_is_prime(n, times - 1)
         : false;
}

function expmod_strict(base, exp, m, p, k) {
    // console.log(`${base} ${exp} ${m} ${p} ${k}`);
    return p !== 1 && p !== m - 1 && p * p % m == 1
         ? 0
         : exp === 0
         ? p
         : is_even(exp)
         ? expmod_strict(base, exp / 2, m, p, k * k % m)
         : expmod_strict(base, exp - 1, m, p * k % m, k);
}

function miller_rabin_test(n) {
    function try_it(a) {
        return expmod_strict(a, n, n, 1, a) === a;
    }
    return try_it(1 + Math.floor(Math.random() * (n - 1)));
}

function fast_is_prime2(n, times) {
    return times === 0
         ? true
         : miller_rabin_test(n)
         ? fast_is_prime2(n, times - 1)
         : false;
}

/// =============================================
function test() {
    const carmichael_number = 1105;
    console.log(fast_is_prime(carmichael_number, Math.floor(carmichael_number / 2)));
    console.log(fast_is_prime2(carmichael_number, Math.floor(carmichael_number / 2)));
    const prime_number = 137;
    console.log(fast_is_prime(prime_number, 12));
    console.log(fast_is_prime2(prime_number, 12));
    const not_prime_number = 12345;
    console.log(fast_is_prime(not_prime_number, 12));
    console.log(fast_is_prime2(not_prime_number, 12));
}

test();

