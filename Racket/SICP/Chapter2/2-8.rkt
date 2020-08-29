#lang scheme

(define (make-interval a b)
  (if (< a b)
      (cons a b)
      (cons b a)))
(define (lower-bound c)
  (car c))
(define (upper-bound c)
  (cdr c))

(define (sub-interval x y)
  (make-interval (- (lower-bound x) (lower-bound y))
                 (- (upper-bound x) (upper-bound y))))
