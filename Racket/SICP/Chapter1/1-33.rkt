#lang scheme
(define (filter-accumulate-recursion combiner null-value filter term a next b)
  (if (> a b)
      null-value
      (combiner (if (filter a)
                    (term a)
                    null-value)
                (filter-accumulate-recursion
                 combiner
                 null-value
                 filter
                 term
                 (next a)
                 next
                 b))))

(define (filter-accumulate-iteration combiner null-value filter term a next b)
  (define (iter a result)
    (if (> a b)
        result
        (if (filter a)
            (iter (next a) (combiner result (term a)))
            (iter (next a) (combiner result null-value)))))
  (iter a null-value))

(define filter-accumulate filter-accumulate-iteration)

(define (identity x) x)
(define (1+ x) (+ 1 x))
(define (tautology x) #t)

(define (prime? n)
  (if (= n 1)
      #f
      (= n (smallest-divisor n))))

(define (smallest-divisor n)
  (find-divisor n 2))

(define (find-divisor n test-divisor)
  (define (square x) (* x x))
  (cond ((> (square test-divisor) n) n)
        ((divides? test-divisor n) test-divisor)
        (else (find-divisor n (+ test-divisor 1)))))

(define (divides? a b)
  (= (remainder b a) 0))

(define (gcd a b)
  (if (= b 0)
      a
      (gcd b (remainder a b ))))

(define (prime-sum a b)
  (filter-accumulate +
                     0
                     prime?
                     identity
                     a
                     1+
                     b))

(define (coprime-mul n)
  (filter-accumulate *
                     1
                     (lambda (x)
                       (= (gcd x n)
                          1))
                     identity
                     1
                     1+
                     n))