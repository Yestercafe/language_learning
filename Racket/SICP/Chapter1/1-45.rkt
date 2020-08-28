#lang scheme
(define tolerance 0.00001)
(define (fixed-point f first-guess)
  (define (close-enough? v1 v2)
    (< (abs (- v1 v2)) tolerance))
  (define (try guess)
    (let ((next (f guess)))
      (if (close-enough? guess next)
          next
          (try next))))
  (try first-guess))

(define (compose a b)
  (lambda (x) (a (b x))))

(define (repeated func k)
  (cond ((> k 0) (compose func (repeated func (- k 1))))
        (else (lambda (x) x))))

(define (expt base n)
  (if (= n 0)
      1
      ((repeated (lambda (x) (* base x)) n) 1)))

(define (average-damp-n-times f n)
  (define (average-damp f)
    (define (average x y) (/ (+ x y) 2))
    (lambda (x) (average x (f x))))
  ((repeated average-damp n) f))

(define (damped-nth-root n damp-times)
  (lambda (x)
    (fixed-point (average-damp-n-times
                  (lambda (y)
                    (/ x (expt y (- n 1))))
                  damp-times)
                 1.0)))

