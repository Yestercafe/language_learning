#lang scheme

(define (reverse items)
  (define (reverse-aux items res)
    (if (null? items)
        res
        (reverse-aux (cdr items) (cons (car items) res))))
  (reverse-aux items (list)))
