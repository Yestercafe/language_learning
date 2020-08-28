#lang scheme
(define (compose a b)
  (lambda (x) (a (b x))))

(define (repeated func k)
  (cond ((> k 0) (compose func (repeated func (- k 1))))
        (else (lambda (x) x))))

(let ((square (lambda (x) (* x x))))
  ((repeated square 2) 5))