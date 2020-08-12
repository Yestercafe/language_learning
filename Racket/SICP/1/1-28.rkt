#lang scheme
(define (Miller-Rabin-test n)
  (test-iter n (ceiling (/ n 2))))

(define (test-iter n times)
  (cond ((= times 0) #t)
        ((= (expmod (+ 1 (random (- n 1))) (- n 1) n) 1)
         (test-iter n (- times 1)))
        (else #f)))

(define (expmod base exp m)
  (define (square x) (* x x))
  (cond ((= exp 0) 1)
        ((nontrivial-square-root? base m) 0)
        ((even? exp)
         (remainder (square (expmod base (/ exp 2) m))
                    m))
        (else
         (remainder (* base (expmod base (- exp 1) m))
                    m))))

(define (nontrivial-square-root? a n)
  (and (not (= a 1))                   ; a != 1
       (not (= a (- n 1)))             ; a != n-1
       (= 1 (remainder (* a a) n))))   ; 1 ! a^2 MOD n