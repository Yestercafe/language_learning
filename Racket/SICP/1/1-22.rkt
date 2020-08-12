#lang scheme
(define (search-for-primes n)
  (let ((start-time (runtime)))
    (search-for-primes-aux n 3)
    (- (runtime) start-time)))

(define (search-for-primes-aux n c)
  (cond ((= c 0) (display "are primes."))
        ((prime? n)
         (display n)
         (newline)
         (search-for-primes-aux (next-odd n) (- c 1)))
        (else (search-for-primes-aux (next-odd n) c))))

(define (next-odd n)
  (define (even? x) (= (remainder x 2) 0))
  (if (even? n)
      (+ n 1)
      (+ n 2)))

(define (prime? n)
  (= n (smallest-divisor n)))

(define (smallest-divisor n)
  (find-divisor n 2))

(define (find-divisor n test-divisor)
  (define (square x) (* x x))
  (cond ((> (square test-divisor) n) n)
        ((divides? test-divisor n) test-divisor)
        (else (find-divisor n (+ test-divisor 1)))))

(define (divides? a b)
  (= (remainder b a) 0))
