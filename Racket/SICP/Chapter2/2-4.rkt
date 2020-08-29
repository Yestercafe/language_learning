#lang scheme
(define (cons x y)
  (lambda (m) (m x y)))

(define (car z)
  (z (lambda (p q) p)))

(define (cdr z)
  (z (lambda (p q) q)))

(car (cons 0 1))
; (car (lambda (m) (m 0 1)))
; ((lambda (m) (m 0 1)) (lambda (p q) p))
; ((lambda (p q) p) 0 1)