#lang scheme
(define (cont-frac n d k)
  (define (cont-frac-iter n d k i r)
    (cond ((= i 0) r)
          (else (cont-frac-iter n d k (- i 1) (/ (n i) (+ (d i) r))))))
  (cont-frac-iter n d k k 0))

(let ((n (lambda (x) 1))
      (d (lambda (x)
           (if (= (modulo x 3) 2)
               (* 2 (/ (+ 1 x) 3))
               1))))
  (+ 2 (exact->inexact (cont-frac n d 10000))))