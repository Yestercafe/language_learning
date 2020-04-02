(define (fib-iter t m a b)
  (if (< t m)
      (fib-iter (1+ t)
		m
		b
		(+ a b))
      a))

(define (fib n)
  (fib-iter 1 n 0 1))

(write-line (fib 10))

(write-line (fib 11))

(write-line (fib 50))

(write-line (fib 70))
