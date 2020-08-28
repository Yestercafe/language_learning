#lang scheme
(define (gcd x y)
  (if (= y 0)
      x
      (gcd y (remainder x y))))

(define (make-rat n d)
  (define (make-rat-aux n d)
    (define div (abs (gcd n d)))
      (cons (/ n div) (/ d div)))
  (cond ((> d 0)
         (make-rat-aux n d))
        ((< d 0)
         (make-rat-aux (- n) (- d)))
        (else
         (error "Denominator can't be 0."))))

(define (numer x) (car x))
(define (denom x) (cdr x))
(define (print-rat x)
  (let ((n (numer x))
        (d (denom x)))
    (cond ((= n 0)
           (display n)
           (newline))
          ((= d 1)
           (display n)
           (newline))
          (else
           (display n)
           (display "/")
           (display d)
           (newline)))))