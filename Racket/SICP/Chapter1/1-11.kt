fun fr(n: Long): Long {
    return if (n < 3) n
    else fr(n - 1) + 2 * fr(n - 2) + 3 * fr(n - 3)
}

fun fi(n: Long): Long {
    return fiIter(2, 1, 0, 3, n)
}

fun fiIter(a: Long, b: Long, c: Long, cnt: Long, n: Long): Long {
    if (n < 3) return n
    if (cnt > n) return a
    return fiIter(a + 2 * b + 3 * c, a, b, cnt + 1, n)
}

fun main(args: Array<String>) {
//    Boom!
//    println(fr(50))
    println(fi(50))
}

