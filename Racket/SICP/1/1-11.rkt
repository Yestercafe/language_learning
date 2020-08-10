#lang scheme
; recursion version
(define (fr n)
  (if (< n 3)
      n
      (+ (fr (- n 1)) (* 2 (fr (- n 2))) (* 3 (fr (- n 3))))))

; iteration version
(define (fi n)
  {define (fi-iter a b c cnt n)
    (if (> cnt n)
        (if (< n 3)
            n
            a)
        (fi-iter (+ a (* 2 b) (* 3 c)) a b (+ 1 cnt) n))} 
  (fi-iter 2 1 0 3 n))