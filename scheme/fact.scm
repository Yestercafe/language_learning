(define (fact-iter i n res)
  (if (<= i n)
      (fact-iter (1+ i)
		 n
		 (* res i))
      res))

(define (fact n)
  (fact-iter 1 n 1))

(write-line (fact 10))
(write-line (fact 100))
