#lang scheme

(define (pascal row col)
  (cond ((> col row) (error "err: col > row")))
  (if (or (= col 1)
          (= col row))
      1
      (+ (pascal (- row 1) (- col 1)) (pascal (- row 1) col))))