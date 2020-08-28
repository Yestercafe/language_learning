#lang scheme
(define (check-carmichael? n)
  (fast-prime-aux? n (- n 2)))

(define (fast-prime-aux? n times)
  (cond ((= times 0) true)
        ((fermat-test n times) (fast-prime-aux? n (- times 1)))
        (else false)))

(define (fermat-test n times)
  (define (try-it a)
    (= (expmod a n n) a))
  (try-it (- n times)))

(define (expmod base exp m)
  (define (square x) (* x x))
  (cond ((= exp 0) 1)
        ((even? exp)
         (remainder (square (expmod base (/ exp 2) m))
                    m))
        (else
         (remainder (* base (expmod base (- exp 1) m))
                    m))))
