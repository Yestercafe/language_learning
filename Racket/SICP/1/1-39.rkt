#lang scheme
(define (tan-cf x k)
  (define (tan-cf-iter x d k i)
    (cond ((> i k) (d i))
          (else (- (d i)
                   (/ (* x x)
                      (tan-cf-iter x d k (+ i 1)))))))
  (let ((d (lambda (x)
             (- (* 2 x) 1))))
    (/ x (tan-cf-iter x d (- k 1) 1))))

(exact->inexact (tan-cf 1 10000))
(tan 1)