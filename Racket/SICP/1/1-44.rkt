#lang scheme
(define (compose a b)
  (lambda (x) (a (b x))))

(define (repeated func k)
  (cond ((> k 0) (compose func (repeated func (- k 1))))
        (else (lambda (x) x))))

(define (smooth f)
  (define (average x y z) (/ (+ x y z) 3))
  (define dx 0.000001)
  (lambda (x) (average (f (- x dx))
                       (f x)
                       (f (+ x dx)))))


(sin 1)
((smooth sin) 1)
((repeated (smooth sin) 2) 1)
((repeated (smooth sin) 3) 1)
((repeated (smooth sin) 5) 1)
((repeated (smooth sin) 10) 1)