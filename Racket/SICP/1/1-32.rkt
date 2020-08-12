#lang scheme
(define (accumulate-recursion combiner null-value term a next b)
  (if (> a b)
      null-value
      (combiner (term a)
                (accumulate-recursion
                 combiner
                 null-value
                 term
                 (next a)
                 next b))))

(define (accumulate-iteration combiner null-value term a next b)
  (define (iter a result)
    (if (> a b)
        result
        (iter (next a) (combiner result (term a)))))
  (iter a null-value))

(define accumulate accumulate-recursion)

(define (sum term a next b)
  (accumulate + 0 term a next b))

(define (product term a next b)
  (accumulate * 1 term a next b))

(define (identity x) x)
(define (1+ x) (+ 1 x))
