#lang scheme

(define (iterative-improve close-enough? improve)
  (lambda (first-guess)
    (define (try guess)
      (let ((next (improve guess)))
        (if (close-enough? guess next)
            next
            (try next))))
    (try first-guess)))

(define (fixed-point f first-guess)
  (define tolerance 0.00001)
  (define (close-enough? v1 v2)
    (< (abs (- v1 v2)) tolerance))
  (define (improve guess)
    (f guess))
  ((iterative-improve close-enough? improve) first-guess))

(define (sqrt x)
  (define (close-enough? a b)
    (< (abs (- a b)) 0.000001))
  (define (improve guess)
    (define (average a b) (/ (+ a b) 2))
    (average guess (/ x guess)))
  ((iterative-improve close-enough? improve) 1.0))