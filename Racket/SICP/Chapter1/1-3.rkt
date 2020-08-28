#lang scheme
(define a 3)
(define b (+ a 1))
(cond ((> a b) a)
      ((< a b) b)
      (else -1))
