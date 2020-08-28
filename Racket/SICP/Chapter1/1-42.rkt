#lang scheme
(define (compose a b)
  (lambda (x) (a (b x))))

(let ((square (lambda (x) (* x x)))
      (inc (lambda (x) (+ 1 x))))
  ((compose square inc) 6))