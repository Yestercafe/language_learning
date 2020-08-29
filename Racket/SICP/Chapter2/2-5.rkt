#lang scheme
(define (pow a n)
  (if (= n 0)
      1
      (* a (pow a (- n 1)))))

(define (cons a b)
  (* (pow 2 a)
     (pow 3 b)))

(define (car p)
  (if (= (remainder p 2) 0)
      (+ 1 (car (/ p 2)))
      0))

(define (cdr p)
  (if (= (remainder p 3) 0)
      (+ 1 (car (/ p 3)))
      0))

(define p (cons 4 5))
(car p)
(cdr p)

