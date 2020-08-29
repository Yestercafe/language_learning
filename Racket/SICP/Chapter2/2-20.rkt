#lang scheme

(define (append list1 list2)
  (if (null? list1)
      list2
      (cons (car list1) (append (cdr list1) list2))))

(define (same-parity first . remain)
  (define (same-parity-aux first remain res)
    (define (odd x) (remainder x 2))
    (if (null? remain)
        res
        (if (= (odd first) (odd (car remain)))
            (same-parity-aux first
                             (cdr remain)
                             (append res (list (car remain))))
            (same-parity-aux first (cdr remain) res))))
  (same-parity-aux first remain (list first)))

(same-parity 1 2 3 4 5 6 7)
(same-parity 2 3 4 5 6 7)