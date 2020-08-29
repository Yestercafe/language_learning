#lang scheme
(define (make-interval a b)
  (if (< a b)
      (cons a b)
      (cons b a)))
(define (lower-bound c)
  (car c))
(define (upper-bound c)
  (cdr c))

(define (center c)
  (/ (+ (upper-bound c) (lower-bound c)) 2))

(define (make-center-percent mid pct)
  (let ((delta (* mid (/ pct 100.))))
    (make-interval (- mid delta)
                   (+ mid delta))))

(define (percent c)
  (* 100 (/ (- (upper-bound c) (center c)) (center c))))

(define (print-interval c)
  (display "[")
  (display (lower-bound c))
  (display ",")
  (display (upper-bound c))
  (display "]")
  (newline))