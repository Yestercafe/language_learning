#lang scheme
(define (inc x) (+ 1 x))
(define (double p)
  (lambda (x) (p (p x))))

(((double (double double)) inc) 5)

; (((double (double (lambda (x) (double (double x))) inc) 5)
; ...
; (((lambda (x) (double (double x)))^4 inc) 5)
; inc^16 5
; 
