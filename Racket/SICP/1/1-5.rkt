#lang scheme
(define (p) (p))
(define (test x y)
  (if (= x 0)
      0
      y))
; Applicative order