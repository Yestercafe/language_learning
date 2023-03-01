#lang scheme
(define (equal? a b)
  (if (and (nil? a) (nil? b))
      t
      (and (eq? (car a) (car b))
           (equal? (cdr a) (cdr b)))))
