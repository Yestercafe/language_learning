#lang scheme

(define (product-recursion term a next b)
  (if (> a b)
      1
      (* (term a) (product term (next a) next b))))

(define (product-iteration term a next b)
  (define (iter a result)
    (if (> a b)
        result
        (iter (next a) (* (term a) result))))
  (iter a 1))

(define (product term a next b)
  (product-iteration term a next b))

(define (factorial n)
  (define (identity x) x)
  (define (1+ x) (+ 1 x))
  (product identity 1 1+ n))

(define (cal-pi p)
  (define (1+ x) (+ 1 x))
  (exact->inexact
   (* 4
      (product (lambda (a)
                 (define (even? x)
                   (= (remainder x 2)
                      0))
                 (if (even? a)
                     (/ a (+ a 1))
                     (/ (+ a 1) a)))
               2
               1+
           p))))
