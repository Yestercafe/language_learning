#lang scheme

(define (make-interval a b)
  (if (< a b)
      (cons a b)
      (cons b a)))
(define (lower-bound c)
  (car c))
(define (upper-bound c)
  (cdr c))

(define (width-interval c)
  (- (upper-bound c) (lower-bound c)))

(define (add-interval x y)
  (make-interval (+ (lower-bound x) (lower-bound y))
                 (+ (upper-bound x) (upper-bound y))))
; add:
; set interval(a, b) and interval(c, d)
; (assume a<b and c<d)
; interval(a, b) + interval(c, d) = interval(a+c, b+d)
; width of interval(a, b) is (b-a), width of interval(c, d)
; is (d-c), width of interval(a+c, b+d) is (b+d-a-c).
; So width of the plus of two intervals is equal to the
; plus of each width of two intervals.

(define (sub-interval x y)
  (make-interval (- (lower-bound x) (lower-bound y))
                 (- (upper-bound x) (upper-bound y))))
; sub is same

(define (mul-interval x y)
  (let ((p1 (* (lower-bound x) (lower-bound y)))
        (p2 (* (lower-bound x) (upper-bound y)))
        (p3 (* (upper-bound x) (lower-bound y)))
        (p4 (* (upper-bound x) (upper-bound y))))
    (make-interval (min p1 p2 p3 p4)
                   (max p1 p2 p3 p4))))
; e.g.: interval(1, 2) * interval(1, 2) = iterval(1, 4)
; however, width of interval(1, 2) is 1, width of interval(1, 4) is 3