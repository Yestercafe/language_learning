#lang scheme
(define (cbrt-iter guess prev-guess x)
  (if (good-enough? guess prev-guess)
      guess
      (cbrt-iter (improve guess x)
                 guess
                 x)))

(define (improve guess x)
  (approach guess x))

(define (approach guess x)
  (/ (+ (/ x (square guess)) (* 2 guess))
      3))

(define (good-enough? guess prev-guess)
  (< (abs (- prev-guess guess)) 0.0001))

(define (square x) (* x x))
(define (cube x) (* x x x))

(define (cbrt x)
  (cbrt-iter 1.0 0.0 x))
