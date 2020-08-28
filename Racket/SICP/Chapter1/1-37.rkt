#lang scheme
(define (cont-frac-recursion n d k)
  (define (cont-frac-iter n d k i)
    (cond ((> i k) 0)
          (else (/ (n i) (+ (d i) (cont-frac-iter n d k (+ 1 i)))))))
  (cont-frac-iter n d k 1))

(define (cont-frac-iteration n d k)
  (define (cont-frac-iter n d k i r)
    (cond ((= i 0) r)
          (else (cont-frac-iter n d k (- i 1) (/ (n i) (+ (d i) r))))))
  (cont-frac-iter n d k k 0))

(let ((k 10000))
  (cont-frac-iteration (lambda (i) 1.0)
             (lambda (i) 1.0)
             k))